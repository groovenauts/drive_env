require 'thor'

module DriveEnv
  module Cli
    class Config < Thor
      desc "set key value", ""
      def set(key, value)
        config = DriveEnv::Config.load
        config.instance_variable_set("@#{key}", value)
        config.save
      end

      desc "unset key", ""
      def unset(key)
        config = DriveEnv::Config.load
        config.remove_instance_variable("@#{key}")
        config.save
      end

      desc "list", ""
      def list
        config = DriveEnv::Config.load
        config.each do |k,v|
          puts "#{k}: #{v}"
        end
      end
    end
  end
end

