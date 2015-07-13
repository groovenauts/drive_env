require 'drive_env/version'

module DriveEnv
  autoload :Cli, 'drive_env/cli'
  autoload :Config, 'drive_env/config'

  class << self
    def config
      @config ||= DriveEnv::Config.load
    end

    def client_id
      @client_id ||= self.config.client_id
    end

    def client_secret
      @client_secret ||= self.config.client_secret
    end

    def client
      @client ||= Google::APIClient.new(:application_name => 'drive_env', :application_version => DriveEnv::VERSION)
    end

    def auth
      unless @auth
        @auth = ::DriveEnv.client.authorization
        @auth.client_id = ::DriveEnv.client_id
        @auth.client_secret = ::DriveEnv.client_secret
        @auth.scope = %w[
          https://www.googleapis.com/auth/drive
          https://spreadsheets.google.com/feeds/
        ].join(' ')
        @auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
      end
      @auth
    end

    def access_token(config=::DriveEnv.config)
      unless @access_token
        auth = DriveEnv.auth
        auth.refresh_token = config.refresh_token
        auth.fetch_access_token!
        @access_token = auth.access_token
      end
      @access_token
    end
  end
end
