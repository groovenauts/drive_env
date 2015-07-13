require 'thor'

module DriveEnv
  module Cli
    class Command < Thor
      desc "auth SUBCOMMAND ...ARGS", ""
      subcommand "auth", ::DriveEnv::Cli::Auth
    end
  end
end
