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
        auth = DriveEnv.auth
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
          @config ||= DriveEnv.config(options[:config])
        end
      end
    end
  end
end

