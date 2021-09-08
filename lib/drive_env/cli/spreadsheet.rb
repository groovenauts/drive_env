require 'thor'
require 'text-table'
require 'google_drive'
require 'drive_env'
require 'json'

module DriveEnv
  module Cli
    class Spreadsheet < Thor
      desc 'show SPREADSHEET_URL_OR_ALIAS', ''
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

      desc 'to_env SPREADSHEET_URL_OR_ALIAS', ''
      option :format, type: 'string', default: 'dotenv', enum: %w[dotenv json],
             desc: 'output format'
      def to_env(url_or_alias)
        ws = worksheet(url_or_alias)

        envs = []
        ws.rows.each.with_index do |row, idx|
          row_to_env(row) do |key, value, comment|
            envs << { key: key, value: value, comment: comment }
          end
        end

        case options[:format]
        when 'dotenv'
          envs.each do |env|
            case
            when env[:key] && env[:value] && env[:comment]
              puts "#{env[:key]}=#{env[:value]} #{env[:comment]}"
            when env[:key] && env[:value] && !env[:comment]
              puts "#{env[:key]}=#{env[:value]}"
            when !env[:key] && !env[:value] && env[:comment]
              puts "#{env[:comment]}"
            end
          end
        when 'json'
          puts JSON.pretty_generate(
            envs.select{|env| env[:key] }.map{|env| { key: env[:key], value: env[:value] } }
          )
        end
      end

      desc 'runner SPREADSHEET_URL_OR_ALIAS COMMANDS', ''
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

      desc 'alias NAME SPREADSHEET_URL', ''
      def alias(name, url)
        config.set_alias_for_spreadsheet(name, url)
        config.save
      end

      desc 'unalias NAME', ''
      def unalias(name)
        config.unset_alias_for_spreadsheet(name)
        config.save
      end

      no_commands do
        def config
          @config ||= DriveEnv::Config.load(options[:config])
        end

        def authorizer
          DriveEnv.authorizer(config.client_id, config.client_secret, DriveEnv::Config::DEFAULT_TOKENS_STORE_FILE)
        end

        def credential
          unless @credential
            case authorizer
            when Google::Auth::UserAuthorizer
              @credential = authorizer.get_credentials(DriveEnv::Config::DEFAULT_TOKEN_USER_ID)
              case
              when @credential.nil?
                abort "please set access_token: #{$0} auth login"
              when @credential.expired?
                @credential.fetch_access_token!
                @credential.expires_at = credential.issued_at + credential.expires_in
                authorizer.store_credentials(DriveEnv::Config::DEFAULT_TOKEN_USER_ID, @credential)
              end
            when Google::Auth::ServiceAccountCredentials
              @credential = authorizer
              @credential.fetch_access_token!
            end
          end
          @credential
        end

        def session
          @session ||= GoogleDrive::Session.login_with_oauth(credential)
        end

        def worksheet(url_or_alias)
          url = config.lookup_spreadsheet_url_by_alias(url_or_alias) || url_or_alias
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
