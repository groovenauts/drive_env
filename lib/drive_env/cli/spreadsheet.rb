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
          row_to_env(row) do |key, value, comment|
            case
            when key && value && comment
              puts "#{key}=#{value} #{comment}"
            when key && value && !comment
              puts "#{key}=#{value}"
            when !key && !value && comment
              puts comment
            end
          end
        end
      end

      desc "runner SPREADSHEET_URL_OR_ALIAS COMMANDS", ""
      def runner(url_or_alias, *commands)
        ws = worksheet(url_or_alias)
        ws.rows.each.with_index do |row, idx|
          row_to_env(row) do |key, value, comment|
            case
            when key && value
              ENV[key] = value
            end
          end
        end
        system(*commands)
      end

      desc "alias NAME SPREADSHEET_URL", ""
      def alias(name, url)
        config.set_alias_for_spreadsheet(name, url)
        config.save(options[:config])
      end

      desc "unalias NAME", ""
      def unalias(name)
        config.unset_alias_for_spreadsheet(name)
        config.save(options[:config])
      end

      no_commands do
        def config
          @config ||= DriveEnv::Config.load(options[:config])
        end

        def session
          @session ||= GoogleDrive.login_with_oauth(DriveEnv.access_token(options[:config]))
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

        def row_to_env(row)
          if row[0] =~ /\A\s*#/
            comment = row.join(' ')
            yield nil, nil, comment
          else
            key = row[0]
            value = row[1]
            others = row[2..-1].join(' ')
            case [key, value, others].map{|v| !v.strip.empty?}
            when [true, true, true]
              yield key, value, "# #{others}"
            when [true, true, false]
              yield key, value, nil
            when [true, false, true]
              yield key, '', "# #{others}"
            when [true, false, false]
              yield nil, nil, "# #{key}="
            when [false, true, true]
              # ignore
            when [false, true, false]
              # ignore
            when [false, false, true]
              yield nil, nil, "# #{others}"
            when [false, false, false]
              # ignore
            end
          end
        end
      end
    end
  end
end

