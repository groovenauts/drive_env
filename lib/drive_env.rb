require 'drive_env/version'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module DriveEnv
  autoload :Cli,     'drive_env/cli'
  autoload :Config,  'drive_env/config'

  class << self
    def authorizer(client_id, client_secret, token_store_file)
      unless @authorizer
        cred = ENV['GOOGLE_APPLICATION_CREDENTIALS']
        scope = %w[
          https://www.googleapis.com/auth/drive
          https://spreadsheets.google.com/feeds/
        ]
        if cred.nil?
          client_id = Google::Auth::ClientId.new(client_id, client_secret)
          token_store = Google::Auth::Stores::FileTokenStore.new(file: token_store_file)
          @authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
        else
          @authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: File.open(cred),
            scope: scope
          )
        end
      end
      @authorizer
    end
  end
end
