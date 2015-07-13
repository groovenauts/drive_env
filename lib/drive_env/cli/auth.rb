require 'thor'
require 'google_drive'

module DriveEnv
  module Cli
    class Auth < Thor
      desc "login", ""
      def login
        client = DriveEnv.client
        auth = DriveEnv.auth
        print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
        print("2. Enter the authorization code shown in the page: ")
        auth.code = $stdin.gets.chomp
        auth.fetch_access_token!
        access_token = auth.access_token
        config = DriveEnv.config
        config.access_token = access_token
        config.save
      end
    end
  end
end

