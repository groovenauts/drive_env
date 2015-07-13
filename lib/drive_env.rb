require 'drive_env/version'

module DriveEnv
  autoload :Cli, 'drive_env/cli'
  autoload :Config, 'drive_env/config'

  class << self
    def client
      @client ||= Google::APIClient.new(:application_name => 'drive_env', :application_version => DriveEnv::VERSION)
    end
  end
end
