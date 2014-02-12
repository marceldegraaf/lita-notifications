require "lita"

module Lita
  module Handlers
    class Kitchen < Handler

      http.post "/lita/kitchen/notify", :notify

      def notify(request, response)
        source = Source.new(user: Lita.config.robot.name, room: "Ops")
        query = request.POST

        user        = query["user"]
        application = query["application"]
        message     = query["message"]

        robot.send_messages(source, "[#{application}] #{message} (by #{user})")
      end

    end

    Lita.register_handler(Kitchen)
  end
end
