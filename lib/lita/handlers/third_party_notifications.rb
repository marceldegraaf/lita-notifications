require "lita"

module Lita
  module Handlers
    class ThirdPartyNotifications < Handler

      http.post "/notifications/kitchen", :kitchen

      def self.default_config(config)
        config.channel = "#general"
      end

      def kitchen(request, response)
        user        = query(:user)
        application = query(:application)
        message     = query(:message)

        reply "[#{application}] #{message} (by #{user})"
      end

      private

      def reply(message)
        robot.send_messages(source, message)
      end

      def query(field)
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

    end

    Lita.register_handler(ThirdPartyNotifications)
  end
end
