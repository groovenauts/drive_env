require 'thor'

module DriveEnv
  module Cli
    class Command < Thor
      desc "auth SUBCOMMAND ...ARGS", ""
      subcommand "auth", ::DriveEnv::Cli::Auth

      desc "config SUBCOMMAND ...ARGS", ""
      subcommand "config", ::DriveEnv::Cli::Config
    end
  end
end
