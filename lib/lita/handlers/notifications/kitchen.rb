module Lita
  module Handlers
    module Notifications
      class Kitchen < Notifications

        http.post "/notifications/kitchen", :kitchen

        def kitchen(request, response)
          return error(response, 404) unless enabled?
          return error(response, 401) unless authorized?(request)

          user        = query(:user, request)
          application = query(:application, request)
          message     = query(:message, request)

          reply "[#{application}] #{message} (by #{user})"

        rescue => error
          rescue_error(error)

        end

        def name
          :kitchen
        end

        def icon_url
          "https://dl.dropboxusercontent.com/u/3257729/lita-notifications/wakoopa.png"
        end

        def bot_name
          "Kitchen"
        end

      end

      Lita.register_handler(Kitchen)
    end
  end
end
