require 'thor'
require 'drive_env'

module DriveEnv
  module Cli
    class Auth < Thor
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

      desc 'login', ''
      def login
        if !config.client_id
          abort "please set client_id: #{$0} config set client_id YOUR_CLIENT_ID"
        end
        if !config.client_secret
          abort "please set client_secret: #{$0} config set client_secret YOUR_CLIENT_SECRET"
        end
        print("1. Open this page:\n%s\n\n" % authorizer.get_authorization_url(base_url: OOB_URI))
        print("2. Enter the authorization code shown in the page: ")

        code = $stdin.gets.chomp
        authorizer.get_and_store_credentials_from_code(user_id: DriveEnv::Config::DEFAULT_TOKEN_USER_ID, code: code, base_url: OOB_URI)
      end

      no_commands do
        def config
          @config ||= DriveEnv::Config.load(options[:config])
        end

        def authorizer
          DriveEnv.authorizer(config.client_id, config.client_secret, DriveEnv::Config::DEFAULT_TOKENS_STORE_FILE)
        end
      end
    end
  end
end

