# frozen_string_literal: true

require 'retriable'
require 'dry-types'
require 'faraday'
require 'json'
require 'representable/json'
require 'websocket-eventmachine-client'
require_relative 'hawkr/version'
require_relative 'rom_boot'
# http based
require_relative 'markets/livecoin'
require_relative 'markets/coinone'
require_relative 'markets/bithumb'
require_relative 'markets/quoine'
require_relative 'markets/bter'
require_relative 'markets/kraken'
# Bitstamp can work through pusher, however pusher is shit
require_relative 'markets/bitstamp'
# chinese bullshit require_relative 'markets/btc38'
# russian? php bullshit api without docs.. coinsbank
# websocket based
require_relative 'markets/gdax'
require_relative 'markets/bitfinex'
# Poloniex is working, but have somehat long initiation, dunno why
require_relative 'markets/poloniex'
# require_relative 'markets/binance'
# TODO: bitflyer is blocked for me
# require_relative 'markets/bitflyer'
# TODO: korbit is blocked for me
# require_relative 'markets/korbit'
# require_relative 'markets/gemini'
# require_relative 'markets/okcoin'

# This is localbitcoins
# bitflyerjpy
# btcboxjpy
# btcoididr
# cexiousd
# coincheckjpy
# coinfloorgbp
# getbtcusd
# hitbtcusd
# korbit
# lakeusd
# oitbitusd
# okcoinusd
# wexusd
# zaifjpy
# Bitcoin Charts - https://bitcoincharts.com/markets/list/
# Bitpay
# BitcoinAverage
#
# This is bitcoinaverage.com
# Gemini doing
# Bittrex
# Poloniex
# CEX.IO
# Hitbtc
# Exmoney
# QuadrigaCX
# Bitex.la
# Rock Trading
# Bitsquare
# Independent Reserve

require 'raven/base'

Raven.configure do |config|
  config.dsn = 'https://d9f6fd3569114796b4d606aee5cf3521:5619d906e1ea4aa2b987cef7c4ce7376@s.crypto.deals//4'
  config.transport_failure_callback = lambda { |event|
    puts 'Failed to send error to sentry'
    puts event
  }
end

module Hawkr
end

module Types
  include Dry::Types.module
end

repo = RomBoot.new.tickers_repo

if ENV['RUN']
  Raven.capture do
    threads = []
    [
      Markets::Bitfinex,
      Markets::Livecoin,
      Markets::Coinone,
      Markets::Bithumb,
      Markets::Quoine,
      # Markets::Bter, # They disabled api
      Markets::Kraken,
      Markets::Bitstamp,
      Markets::Gdax,
      # Markets::Poloniex, # wamp unstable
    ].each do |market|
      threads << Thread.new do
        begin
          Retriable.retriable do
            market.new(repo: repo).start
          end
        rescue StandardError => e
          puts "RESCUE #{market} #{e.inspect}"
          # run this if retriable ends up re-rasing the exception
        else
          puts "ok #{market}"
          # run this if retriable doesn't raise any exceptions
        end
      end
    end

    threads.each(&:join)
  end
end

class TickerRepresenter < Representable::Decorator
  include Representable::JSON

  collection :to_a, as: :tickers do
    # property :time, default: Time.now
    property :unique_ticker
    # property :market
    # property :currency
    # property :ticker
    property :price, render_filter: ->(input, _options) { input.to_f }
    property :bid, render_filter: ->(input, _options) { input.to_f }
    property :ask, render_filter: ->(input, _options) { input.to_f }
    property :low_24h, render_filter: ->(input, _options) { input.to_f }
    property :high_24h, render_filter: ->(input, _options) { input.to_f }
    property :avg_24h, render_filter: ->(input, _options) { input.to_f }
    property :volume_24h, render_filter: ->(input, _options) { input.to_f }
    property :volume_30d, render_filter: ->(input, _options) { input.to_f }
  end
end

if ENV['RUNSERVER']
  require 'roda'
  require 'readthis'
  require 'oj'

  Readthis.fault_tolerant = true
  Readthis.serializers << Oj
  # Freeze the serializers to ensure they aren't changed at runtime.
  Readthis.serializers.freeze!

  class App < Roda
    route do |r|
      @cache ||= Readthis::Cache.new(
        expires_in: 60, # 1 minute
        redis: { url: 'redis://redis:6380/2', driver: :hiredis },
        marshal: Oj
      )
      @repo ||= RomBoot.new.tickers_repo
      response['Content-Type'] = 'application/json'

      r.root do
        @cache.fetch('markets') do |key|
          result = TickerRepresenter.new(@repo.markets.to_a).to_json

          @cache.write(key, result)
          result
        end
      end

      r.is 'crypto' do
        r.get do
          @cache.fetch('crypto') do |key|
            representer = TickerRepresenter.new(@repo.markets.to_a)
            result = representer.to_hash['tickers'].each_with_object({}) do |t, m|
              unique_ticker = t.delete('unique_ticker')
              market = t.each_with_object({}) { |(k,v), m| m["#{unique_ticker}:#{k}".downcase.tr(':','_')] = v }
              m.merge!(market)
            end.to_json
            @cache.write(key, result)
            result
          end
        end
      end
    end
  end
end
