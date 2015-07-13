require 'thor'
require 'text-table'
require 'google_drive'

module DriveEnv
  module Cli
    class Spreadsheet < Thor
      desc "show SPREADSHEET_URL_OR_ALIAS", ""
      def show(url_or_alias)
        ws = worksheet(url_or_alias)
        table = Text::Table.new
        ws.rows.each.with_index do |row, idx|
          if idx == 0
            table.head = row
          else
            table.rows << row
          end
        end

        puts table.to_s
      end

      desc "to_env SPREADSHEET_URL_OR_ALIAS", ""
      def to_env(url_or_alias)
        ws = worksheet(url_or_alias)
        ws.rows.each.with_index do |row, idx|
          if row[0] =~ /\A\s*#/
            puts row.join(' ')
          elsif row.size > 2
            puts "#{row[0]}=#{row[1]} # #{row[2..-1].join(' ')}"
          elsif row.size == 2
            puts "#{row[0]}=#{row[1]}"
          elsif row.size == 1
            puts "# #{row[0]}"
          else
            # ignore
          end
        end
      end

      desc "alias NAME SPREADSHEET_URL", ""
      def alias(name, url)
        config.set_alias_for_spreadsheet(name, url)
        config.save
      end

      desc "unalias NAME", ""
      def unalias(name)
        config.unset_alias_for_spreadsheet(name)
        config.save
      end

      no_commands do
        def config
          unless @config
            @config = DriveEnv::Config.load
          end
          @config
        end

        def session
          unless @session
            @session = GoogleDrive.login_with_oauth(config.access_token)
          end
          @session
        end

        def worksheet(url_or_alias)
          url = config.lookup_spreadsheet_url_by_alias(url_or_alias)
          unless url
            url = url_or_alias
          end
          spreadsheet = session.spreadsheet_by_url(url)
          if url =~ /#gid=(\d+)/
            spreadsheet.worksheet_by_gid($1)
          else
            spreadsheet.worksheets[0]
          end
        end
      end
    end
  end
end

