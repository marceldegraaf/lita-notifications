require "lita"
require "json"

module Lita
  module Handlers
    class Notifications < Handler

      #
      # Always specify the token in the query parameters of the request
      # e.g. http://lita.example.com/notifications/example?token=<token>
      #

      http.post "/notifications/kitchen", :kitchen
      http.post "/notifications/github", :github

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

      #
      # Notifications from Github
      #
      # Query params:
      #   payload = JSON-formatted string with Github payload
      #
      def github(request, response)
        error(response, 401) and return unless authenticated?(request)
        error(response, 404) and return unless enabled?(:github)
        error(response, 500) and return unless request.env["HTTP_X_GITHUB_EVENT"]

        type = request.env["HTTP_X_GITHUB_EVENT"]
        hash = JSON.load(request.body.read)

        if type == "ping"
          reply "Received a ping request from Github's webhook!"

        else
          commit      = hash["after"]
          compare     = hash["compare"]
          branch      = hash["ref_name"]
          repository  = hash["repository"]["name"]
          num_commits = hash["commits"].size

          if num_commits > 1
            author  = hash["head_commit"]["committer"]["name"]
            label   = "[#{repository}]"
            message = "pushed #{num_commits} to #{branch}"
          else
            author  = hash["commits"].first["author"]["name"]
            label   = "[#{repository}/#{branch}]"
            message = hash["commits"].first["message"]
          end

          reply "#{label} #{message} – #{compare} (#{author})"

        end
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
        Lita.config.handlers.notifications
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

    Lita.register_handler(Notifications)
  end
end
