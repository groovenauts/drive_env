require 'spec_helper'
require 'shellwords'

describe DriveEnv::Cli::Config do
  let (:config_file) do
    File.expand_path("#{__dir__}/../../tmp/empty-config")
  end

  around do |example|
    File.unlink(config_file) if File.exist?(config_file)
    example.run
    File.unlink(config_file) if File.exist?(config_file)
  end

  it "config set" do
    run_cli "config set client_id DUMMY_CLIENT_ID -c #{config_file}"
    config_list = capture(:stdout) do
      run_cli "config list -c #{config_file}"
    end
    expect(config_list).to match(/^client_id: DUMMY_CLIENT_ID$/)
  end

  it "config unset" do
    run_cli "config set client_id DUMMY_CLIENT_ID -c #{config_file}"
    run_cli "config set client_secret DUMMY_CLIENT_SECRET -c #{config_file}"
    run_cli "config unset client_id -c #{config_file}"
    config_list = capture(:stdout) do
      run_cli "config list -c #{config_file}"
    end
    expect(config_list).to     match(/^client_secret: DUMMY_CLIENT_SECRET$/)
    expect(config_list).not_to match(/^client_id: DUMMY_CLIENT_id$/)
  end
end
