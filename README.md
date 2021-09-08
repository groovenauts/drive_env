# DriveEnv

[![Gem Version](https://badge.fury.io/rb/drive_env.png)](https://rubygems.org/gems/drive_env)
[![Build Status](https://travis-ci.org/groovenauts/drive_env.svg?branch=master)](https://travis-ci.org/groovenauts/drive_env)

Generate `.env` file from Spreadsheet in Google Drive.

```
$ drive_env spreadsheet to_env 'https://docs.google.com/spreadsheets/d/*********/edit#gid=0'
# name value comment
RAILS_ENV=production # production or testing or development
DATABASE_HOSTNAME=x.x.x.x # IP address of Database
DATABASE_USERNAME=appuser # Username of Database
DATABASE_PASSWORD=appuser # Password of Database
DATABASE_NAME=foo_production # Name of Database
SMTP_HOST=x.x.x.x
SMTP_USERNAME=appuser
SMTP_PASSWORD=appuser
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'drive_env'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drive_env

## Usage

First, you need to login Google Cloud Platform and enable APIs. We support authentication with `User account` and `Service account`.

### User authentication

1. Open [API library page](https://console.developers.google.com/apis/library)
2. Create/Select project
3. Enable "Google Drive API" and "Google Sheets API"
4. Open [Credentials page](https://console.developers.google.com/apis/credentials) in the same project
5. Click "Create credentials" and choose "OAuth client ID"
6. Choose "Other" for "Application type", and click "create"
7. Note CLIENT ID, CLIENT_SECRET

Setup client_id, client_secret, and login.

```
$ drive_env config set client_id YOUR_CLIENT_ID
$ drive_env config set client_secret YOUR_CLIENT_SECRET
$ drive_env auth login
```

Now you have access token and refresh token, you can access to Google APIs.

### Service account authentication

1. Open [API library page](https://console.developers.google.com/apis/library)
2. Create/Select project
3. Enable "Google Drive API" and "Google Sheets API"
4. Open [Credentials page](https://console.developers.google.com/apis/credentials) in the same project
5. Click "Create credentials" and choose "Service account key"
6. Save credentials as JSON file
7. Set `GOOGLE_APPLICATION_CREDENTIALS` environment variables with the value of the downloaded JSON file path.
  ```
  $ export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service_account_credential.json"
  ```

The application search `GOOGLE_APPLICATION_CREDENTIALS` first and then try to use user credential.

### Access Spreadsheet

Show Spreadsheet in Google Drive:

```
$ drive_env spreadsheet show 'https://docs.google.com/spreadsheets/d/*********/edit#gid=0'
```

You can add alias for Spreadsheet.

```
$ drive_env spreadsheet alias sheet1 'https://docs.google.com/spreadsheets/d/*********/edit#gid=0'
$ drive_env spreadsheet show sheet1
```

### `drive_env spreadsheet to_env`

`drive_env spreadsheet to_env` with following Spreadsheet

![Spreadsheet](spreadsheet.png)

will generate dotenv gem friendly format.

```
$ drive_env spreadsheet to_env sheet1
# name value comment
RAILS_ENV=production # production or testing or development
DATABASE_HOSTNAME=x.x.x.x # IP address of Database
DATABASE_USERNAME=appuser # Username of Database
DATABASE_PASSWORD=appuser # Password of Database
DATABASE_NAME=foo_production # Name of Database
SMTP_HOST=x.x.x.x
SMTP_USERNAME=appuser
SMTP_PASSWORD=appuser
```

Redirect to file `.env`, and then you can use with dotenv gem.

```
$ drive_env spreadsheet to_env sheet1 > .env
$ your-ruby-application-with-dotenv-gem
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/groovenauts/drive_env.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
