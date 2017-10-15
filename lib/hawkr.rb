require 'byebug'
require 'dry-types'
require 'faraday'
require 'json'
require 'representable/json'
require 'websocket-eventmachine-client'
require 'hawkr/version'
require 'rom_boot'
require_relative 'markets/livecoin'
require_relative 'markets/gdax'
require 'raven/base'

Raven.configure do |config|
  config.dsn = 'https://d9f6fd3569114796b4d606aee5cf3521:5619d906e1ea4aa2b987cef7c4ce7376@s.crypto.deals//4'
end

module Hawkr
end

module Types
  include Dry::Types.module
end

repo = RomBoot.new.tickers_repo

Raven.capture do
  threads = []
  [Markets::Livecoin, Markets::Gdax].each do |market|
    threads << Thread.new do
      market.new(repo: repo).start
    end
  end

  threads.each(&:join)
end
puts 'done'
