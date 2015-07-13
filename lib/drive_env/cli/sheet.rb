require 'thor'
require 'text-table'
require 'google_drive'

module DriveEnv
  module Cli
    class Sheet < Thor
      desc "rows SHEET_URI", ""
      def show(uri)
        ws = session.spreadsheet_by_url(uri).worksheets[0]
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

