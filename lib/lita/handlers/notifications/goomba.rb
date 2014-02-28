module Lita
  module Handlers
    module Notifications
      class Goomba < Notifications
        http.post '/notifications/goomba', :kitchen

        def kitchen(request, response)
          return error(response, 404) unless enabled?
          return error(response, 401) unless authorized?(request)

          alarm  = query(:alarm, request)
          reason = query(:reason, request)

          reply ":warning: #{alarm}: #{reason}"

        rescue => error
          rescue_error(error)
        end

        def name
          :kitchen
        end

        def icon_url
          'http://images3.wikia.nocookie.net/__cb20121207200146/nintendo/en/images/2/2a/New_Super_Mario_Bros_Wii_Goomba.jpeg'
        end

        def bot_name
          'Goomba'
        end
      end

      Lita.register_handler(Goomba)
    end
  end
end
