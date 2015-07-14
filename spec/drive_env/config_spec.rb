require 'spec_helper'

describe DriveEnv::Config do
  describe "load empty file" do
    let(:config_file) do
      File.expand_path("#{__dir__}/../tmp/empty-config")
    end

    around do |example|
      File.unlink(config_file) if File.exist?(config_file)
      example.run
      File.unlink(config_file) if File.exist?(config_file)
    end

    it "save config" do
      conf = DriveEnv::Config.load(config_file)
      conf.save
      expect(File.exist?(config_file)).to be_truthy
    end

    it "load config" do
      conf1 = DriveEnv::Config.load(config_file)
      conf1.client_id = "DUMMY_CLIENT_ID"
      conf1.save
      conf2 = DriveEnv::Config.load(config_file)
      expect(conf2.client_id).to eq conf1.client_id
    end
  end

  describe "spreadsheet alias" do
    let(:config_file) do
      File.expand_path("#{__dir__}/../tmp/empty-config")
    end

    let(:spreadsheet_aliases) do
      {
        "alias1" => "https://docs.google.com/spreadsheets/d/aaaa/edit#gid=0",
        "alias2" => "https://docs.google.com/spreadsheets/d/bbbb/edit#gid=123"
      }
    end

    around do |example|
      File.unlink(config_file) if File.exist?(config_file)
      conf = DriveEnv::Config.load(config_file)
      spreadsheet_aliases.each do |k,v|
        conf.set_alias_for_spreadsheet(k,v)
      end
      conf.save
      example.run
      File.unlink(config_file) if File.exist?(config_file)
    end

    it "lookup_spreadsheet_url_by_alias" do
      conf = DriveEnv::Config.load(config_file)
      expect(conf.lookup_spreadsheet_url_by_alias("alias1")).to eq spreadsheet_aliases["alias1"]
    end

    it "unset_alias_for_spreadsheet" do
      conf = DriveEnv::Config.load(config_file)
      conf.unset_alias_for_spreadsheet("alias2")
      expect(conf.lookup_spreadsheet_url_by_alias("alias2")).to be_nil
    end
  end
end
