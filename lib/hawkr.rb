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

module Hawkr
end

module Types
  include Dry::Types.module
end

repo = RomBoot.new.tickers_repo

# Markets::Livecoin.new(repo: repo).start
Markets::Gdax.new(repo: repo).start
puts 'done'
