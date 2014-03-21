module Lita
  module Handlers
    module Notifications
      class Github < Notifications

        http.post "/notifications/github", :github

        def github(request, response)
          return error(response, 404) unless enabled?
          return error(response, 401) unless authorized?(request)
          return error(response, 500) unless request.env["HTTP_X_GITHUB_EVENT"]

          type = request.env["HTTP_X_GITHUB_EVENT"]
          hash = JSON.load(request.body.read)

          if type == "ping"
            reply "Received a ping request from Github's webhook!"

          elsif hash["delete"] == true
            branch      = hash["ref"].split("/").last
            repository  = hash["repository"]["name"]
            label       = "[#{repository}]"
            message     = "branch '#{branch}' was deleted"

            reply "#{label} #{message}"

          else
            commit      = hash["after"]
            compare     = hash["compare"]
            branch      = hash["ref"].split("/").last
            repository  = hash["repository"]["name"]
            num_commits = hash["commits"].size

            if num_commits > 1
              author  = hash["head_commit"]["committer"]["name"]
              label   = "[#{repository}]"
              message = "pushed #{num_commits} commits to branch #{branch}"
            else
              author  = hash["commits"].first["author"]["name"]
              label   = "[#{repository}/#{branch}]"
              message = hash["commits"].first["message"]
            end

            reply "#{label} #{message} – #{compare} (#{author})"

          end

        rescue => error
          rescue_error(error)

        end

        def name
          :github
        end

        def icon_url
          "https://dl.dropboxusercontent.com/u/3257729/lita-notifications/github.jpg"
        end

        def bot_name
          "Github"
        end
      end

      Lita.register_handler(Github)
    end
  end
end
