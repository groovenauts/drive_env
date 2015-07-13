require 'thor'
require 'text-table'
require 'google_drive'

module DriveEnv
  module Cli
    class Spreadsheet < Thor
      desc "show SHEET_URI", ""
      def show(uri)
        spreadsheet = session.spreadsheet_by_url(uri)
        if uri =~ /#gid=(\d+)/
          ws = spreadsheet.worksheet_by_gid($1)
        else
          ws = spreadsheet.worksheets[0]
        end
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

      desc "to_env SHEET_URI", ""
      def to_env(uri)
        spreadsheet = session.spreadsheet_by_url(uri)
        if uri =~ /#gid=(\d+)/
          ws = spreadsheet.worksheet_by_gid($1)
        else
          ws = spreadsheet.worksheets[0]
        end
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

      no_commands do
        def session
          unless @session
            config = DriveEnv::Config.load
            @session = GoogleDrive.login_with_oauth(config.access_token)
          end
          @session
        end
      end
    end
  end
end

