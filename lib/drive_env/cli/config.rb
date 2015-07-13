require 'thor'

module DriveEnv
  module Cli
    class Config < Thor
      desc "set key value", ""
      def set(key, value)
        config.instance_variable_set("@#{key}", value)
        config.save(options[:config])
      end

      desc "unset key", ""
      def unset(key)
        config.remove_instance_variable("@#{key}")
        config.save(options[:config])
      end

      desc "list", ""
      def list
        puts YAML.dump(config)
      end

      no_commands do
        def config
          @config ||= DriveEnv::Config.load(options[:config])
        end
      end
    end
  end
end

