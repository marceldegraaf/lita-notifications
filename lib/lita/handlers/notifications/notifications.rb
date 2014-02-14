#autoload :Handler, "lita/handler"

module Lita
  module Handlers
    module Notifications
      class Notifications < Lita::Handler

        def self.default_config(config)
          config.channel  = "#general"
          config.services = []
        end

        def name
          raise "Implement me in a subclass"
        end

        def icon_url
          config.icon_url || nil
        end

        def bot_name
          Lita.config.robot.name
        end

        private

        def rescue_error(error)
          reply "An error occurred in the #{name} handler: #{error.message}"
        end

        def query(field, request)
          request.POST[field.to_s]
        end

        def reply(message)
          robot.send_messages(source, message)
        end

        def source
          Source.new(user: user, room: config.channel)
        end

        def user
          User.new(bot_name, name: bot_name, icon_url: icon_url)
        end

        def enabled?
          config.services.include?(self.name)
        end

        def authorized?(request)
          request.GET["token"] == config.token
        end

        def error(response, status = 500)
          response.status = status
        end

        def config
          Lita.config.handlers.notifications
        end

      end

      Lita.register_handler(Notifications)
    end
  end
end
