# bundle exec rackup -p 4567
# bundler.io
require 'rubygems'
require 'bundler/setup'

$: << '.'
require 'football_app'

# log = File.new("sinatra.log", "a+")
# $stdout.reopen(log)
# $stderr.reopen(log)

run FootballApp

