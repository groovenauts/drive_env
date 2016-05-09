require 'drive_env/version'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module DriveEnv
  autoload :Cli,     'drive_env/cli'
  autoload :Config,  'drive_env/config'

  class << self
    def authorizer(client_id, client_secret, token_store_file)
      unless @authorizer
        client_id = Google::Auth::ClientId.new(client_id, client_secret)
        scope = %w[
          https://www.googleapis.com/auth/drive
          https://spreadsheets.google.com/feeds/
        ]
        token_store = Google::Auth::Stores::FileTokenStore.new(file: token_store_file)
        @authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
      end
      @authorizer
    end
  end
end
