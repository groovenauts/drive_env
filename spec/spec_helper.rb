$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'drive_env'
require 'stringio'

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

def run_cli(commands)
  argv = Shellwords.split(commands)
  DriveEnv::Cli::Command.start(argv)
end

