require "lita"

module Lita
  module Handlers
    class ThirdPartyNotifications < Handler

      #
      # Always specify the token in the query parameters of the request
      # e.g. http://lita.example.com/notifications/example?token=<token>
      #

      http.post "/notifications/kitchen", :kitchen

      def self.default_config(config)
        config.channel = "#general"
        config.enable_kitchen = true
      end

      #
      # Notifications from Kitchen
      #
      # Query params:
      #   user        = user name
      #   application = application name
      #   message     = message
      #
      def kitchen(request, response)
        error(response, 401) and return unless authenticated?(request)
        error(response, 404) and return unless enabled?(:kitchen)

        user        = query(:user, request)
        application = query(:application, request)
        message     = query(:message, request)

        reply "[#{application}] #{message} (by #{user})"
      end

      private

      def reply(message)
        robot.send_messages(source, message)
      end

      def query(field, request)
        request.POST[field.to_s]
      end

      def source
        Source.new(user: Lita.config.robot.name, room: config.channel)
      end

      def user
        Lita.config.robot.name
      end

      def config
        Lita.config.handlers.third_party_notifications
      end

      def authenticated?(request)
        request.GET["token"] == config.token
      end

      def enabled?(name)
        config.send("enable_#{name}") == true
      end

      def error(response, status)
        response.status = status
      end

    end

    Lita.register_handler(ThirdPartyNotifications)
  end
end
