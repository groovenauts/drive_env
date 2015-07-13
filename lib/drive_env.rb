require "drive_env/version"

module DriveEnv
  autoload :Cli, 'drive_env/cli'
  autoload :Config, 'drive_env/config'

  class << self
    def config
      unless @config
        @config = DriveEnv::Config.load
      end
      @config
    end

    def client_id
      unless @client_id
        @client_id = self.config.client_id
      end
      @client_id
    end

    def client_secret
      unless @client_secret
        @client_secret = self.config.client_secret
      end
      @client_secret
    end

    def client
      unless @client
        @client = Google::APIClient.new
        @auth = @client.authorization
        @auth.client_id = ::DriveEnv.client_id
        @auth.client_secret = ::DriveEnv.client_secret
        @auth.scope = %w[
          https://www.googleapis.com/auth/drive
          https://spreadsheets.google.com/feeds/
        ].join(' ')
        @auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
      end
      @client
    end

    def auth
      unless @auth
        self.client
      end
      @auth
    end
  end
end
