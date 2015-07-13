require 'fileutils'
require 'yaml'

module DriveEnv
  class Config
    DEFAULT_CONFIG_FILE = File.expand_path('~/.config/drive_env/config')

    attr :client_id
    attr :client_secret
    attr :access_token

    include Enumerable

    def each
      instance_variables.each do |key|
        value = instance_variable_get(key)
        yield key.to_s.sub(/\A@/,''), value
      end
    end

    def save(file=DEFAULT_CONFIG_FILE)
      dir = File.dirname(file)
      if !File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end

      File.open(file, 'w') do |fh|
        fh << YAML.dump(self)
      end
    end

    class << self
      def load(file=DEFAULT_CONFIG_FILE)
        if File.exist?(file)
          YAML.load(File.read(file))
        else
          self.new
        end
      end
    end
  end
end
