require 'byebug'
require 'faraday'
require 'json'
require 'representable/json'
require 'websocket-eventmachine-client'
require 'hawkr/version'
require_relative 'markets/livecoin'
require_relative 'markets/gdax'

module Hawkr
end

require 'dry-struct'
require 'rom-sql'
require 'rom-repository'
require 'pg'

module Types
  include Dry::Types.module
end

rom = ROM.container(:sql, 'postgres://localhost/hawkr_db') do |conf|
  class TickersRepo < ROM::Repository[:tickers]
    commands :create
  end

  class Tickers < ROM::Relation[:sql]
    schema do
      attribute :market,     Types::Coercible::String
      attribute :currency,   Types::Coercible::String
      attribute :ticker,     Types::Coercible::String
      attribute :price,      Types::Form::Decimal
      attribute :bid,        Types::Form::Decimal
      attribute :ask,        Types::Form::Decimal
      attribute :low_24h,    Types::Form::Decimal
      attribute :high_24h,   Types::Form::Decimal
      attribute :avg_24h,    Types::Form::Decimal
      attribute :volume_24h, Types::Form::Decimal
      attribute :volume_30d, Types::Form::Decimal
    end
  end

  conf.register_relation(Tickers)
end

# Markets::Livecoin.new(repo: TickersRepo.new(rom)).start
Markets::Gdax.new(repo: TickersRepo.new(rom)).start
puts 'done'
