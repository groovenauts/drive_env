require 'fileutils'
require 'yaml'

module DriveEnv
  class Config
    DEFAULT_CONFIG_FILE = File.expand_path('~/.config/drive_env/config')

    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :refresh_token

    def set_alias_for_spreadsheet(name, url)
      unless @spreadsheet_aliases
        @spreadsheet_aliases = {}
      end
      @spreadsheet_aliases[name] = url
    end

    def unset_alias_for_spreadsheet(name)
      unless @spreadsheet_aliases
        @spreadsheet_aliases = {}
      end
      @spreadsheet_aliases.delete(name)
    end

    def lookup_spreadsheet_url_by_alias(name)
      unless @spreadsheet_aliases
        @spreadsheet_aliases = {}
      end
      @spreadsheet_aliases[name]
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
