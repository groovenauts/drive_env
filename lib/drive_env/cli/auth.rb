require 'thor'
require 'google_drive'

module DriveEnv
  module Cli
    class Auth < Thor
      desc "login", ""
      def login
        if !config.client_id
          abort "please set client_id: #{$0} config set client_id YOUR_CLIENT_ID"
        end
        if !config.client_secret
          abort "please set client_secret: #{$0} config set client_secret YOUR_CLIENT_SECRET"
        end
        print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
        print("2. Enter the authorization code shown in the page: ")
        auth.code = $stdin.gets.chomp
        auth.fetch_access_token!
        config.access_token = auth.access_token
        config.refresh_token = auth.refresh_token
        config.expires_at = auth.issued_at + auth.expires_in
        config.save
      end

      no_commands do
        def config
          @config ||= DriveEnv::Config.load(options[:config])
        end

        def auth
          unless @auth
            @auth = ::DriveEnv.client.authorization
            @auth.client_id = config.client_id
            @auth.client_secret = config.client_secret
            @auth.scope = %w[
              https://www.googleapis.com/auth/drive
              https://spreadsheets.google.com/feeds/
            ].join(' ')
            @auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
          end
          @auth
        end
      end
    end
  end
end

