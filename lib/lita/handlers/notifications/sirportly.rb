module Lita
  module Handlers
    module Notifications
      class Sirportly < Notifications

        http.post "/notifications/sirportly/new", :kitchen

        def kitchen(request, response)
          hash = request.POST

          message = ":envelope: A new support ticket has been submitted"

          if hash && ticket = hash["ticket"]
            ticket = JSON.load(ticket)
            reference = ticket["reference"]
            subject = ticket["subject"]

            puts subject.inspect

            message << ": \"#{subject}\""

            if config.sirportly_url
              url = "#{config.sirportly_url}/staff/tickets/#{reference}"

              message << " - #{url}"
            end
          end

          reply message

        rescue => error
          rescue_error(error)

        end

        def name
          :kitchen
        end

        def icon_url
          "https://dl.dropboxusercontent.com/u/3257729/lita-notifications/sirportly.jpg"
        end

        def bot_name
          "Sirportly"
        end

      end

      Lita.register_handler(Sirportly)
    end
  end
end
