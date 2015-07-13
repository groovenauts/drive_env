require 'thor'
require 'text-table'
require 'google_drive'

module DriveEnv
  module Cli
    class Sheet < Thor
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

