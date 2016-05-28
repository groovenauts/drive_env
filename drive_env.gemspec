# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drive_env/version'

Gem::Specification.new do |spec|
  spec.name          = "drive_env"
  spec.version       = DriveEnv::VERSION
  spec.authors       = ["YAMADA Tsuyoshi"]
  spec.email         = ["tyamada@minimum2scp.org"]

  spec.summary       = %q{Generate `.env` file from Spreadsheet in Google Drive}
  spec.description   = %q{Generate `.env` file from Spreadsheet in Google Drive}
  spec.homepage      = "https://github.com/groovenauts/drive_env"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "google_drive", "~> 2.0.1"
  spec.add_dependency "google-api-client", "~> 0.9.8"
  spec.add_dependency "googleauth", "~> 0.5.1"
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "text-table", "~> 1.2.4"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
