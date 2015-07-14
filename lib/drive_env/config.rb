require 'fileutils'
require 'yaml'

module DriveEnv
  class Config
    DEFAULT_CONFIG_FILE = File.expand_path('~/.config/drive_env/config')

    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :access_token
    attr_accessor :refresh_token
    attr_accessor :expires_at

    def initialize
      @spreadsheet_aliases = {}
      @config_file = DEFAULT_CONFIG_FILE
    end

    def set_alias_for_spreadsheet(name, url)
      @spreadsheet_aliases[name] = url
    end

    def unset_alias_for_spreadsheet(name)
      @spreadsheet_aliases.delete(name)
    end

    def lookup_spreadsheet_url_by_alias(name)
      @spreadsheet_aliases[name]
    end

    def save
      dir = File.dirname(@config_file)
      if !File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end

      File.open(@config_file, 'w') do |fh|
        fh << YAML.dump(self)
      end
    end

    class << self
      def load(file)
        obj = File.exist?(file) ? YAML.load(File.read(file)) : self.new
        obj.instance_variable_set("@config_file", file)
        obj
      end
    end
  end
end
