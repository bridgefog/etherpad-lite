#!/usr/bin/env ruby

require 'fileutils'
require 'json'
require 'uri'
require 'securerandom'

database_uri = URI.parse(ENV.fetch('DATABASE_URL'))

settings = JSON.parse(File.read(ENV.fetch('ETHERPAD_SETTINGS', 'settings.json')))

settings = settings.merge(
  dbType: database_uri.scheme,
  dbSettings: {
    user: database_uri.user,
    host: database_uri.host,
    password: database_uri.password,
    database: database_uri.path.sub(%r{^/}, '')
  },
)
File.write(File.expand_path('../../settings.json', __FILE__), settings.to_json)

sessionKey = ENV.fetch('SESSION_KEY', SecureRandom.hex)
File.write(File.expand_path('../../SESSION_KEY.txt', __FILE__), sessionKey)

exec(File.expand_path('../run.sh', __FILE__))
