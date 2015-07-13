require 'thor'
require 'drive_env/cli'
require 'drive_env/config'

module DriveEnv
  module Cli
    class Command < Thor
      class_option :config, :aliases =>['c'], :required => false, :type => :string, :default => DriveEnv::Config::DEFAULT_CONFIG_FILE

      desc "auth SUBCOMMAND ...ARGS", ""
      subcommand "auth", ::DriveEnv::Cli::Auth

      desc "config SUBCOMMAND ...ARGS", ""
      subcommand "config", ::DriveEnv::Cli::Config

      desc "spreadsheet SUBCOMMAND ...ARGS", ""
      subcommand "spreadsheet", ::DriveEnv::Cli::Spreadsheet

      desc "version", ""
      def version
        puts "drive_env v#{::DriveEnv::VERSION}"
      end
    end
  end
end
