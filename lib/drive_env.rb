require 'drive_env/version'

module DriveEnv
  autoload :Cli, 'drive_env/cli'
  autoload :Config, 'drive_env/config'

  class << self
    def config(file=::DriveEnv::Config::DEFAULT_CONFIG_FILE)
      @config ||= DriveEnv::Config.load(file)
    end

    def client_id
      @client_id ||= self.config.client_id
    end

    def client_secret
      @client_secret ||= self.config.client_secret
    end

    def client
      @client ||= Google::APIClient.new(
        :application_name => 'drive_env',
        :application_version => DriveEnv::VERSION,
      )
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

    def access_token(file=::DriveEnv::Config::DEFAULT_CONFIG_FILE)
      unless @access_token
        self.auth.expires_at = (self.config.expires_at || Time.now - 3600)
        if self.auth.expired?
          self.auth.refresh_token = self.config.refresh_token
          self.auth.fetch_access_token!
          self.config.access_token = self.auth.access_token
          self.config.expires_at = self.auth.issued_at + self.auth.expires_in
          self.config.save(file) if file
        end
        @access_token = self.config.access_token
      end
      @access_token
    end
  end
end
