# frozen_string_literal: true

require 'byebug'
require 'dry-types'
require 'faraday'
require 'json'
require 'representable/json'
require 'websocket-eventmachine-client'
require 'hawkr/version'
require 'rom_boot'
# http based
require_relative 'markets/livecoin'
require_relative 'markets/coinone'
require_relative 'markets/bithumb'
require_relative 'markets/quoine'
require_relative 'markets/bter'
require_relative 'markets/kraken'
# chinese bullshit require_relative 'markets/btc38'
# websocket based
require_relative 'markets/gdax'
require_relative 'markets/bitfinex'
# require_relative 'markets/bitstamp'
# require_relative 'markets/binance'
# TODO: bitflyer is blocked for me
# require_relative 'markets/bitflyer'
# TODO: korbit is blocked for me
# require_relative 'markets/korbit'
# require_relative 'markets/gemini'
# require_relative 'markets/okcoin'

# This is localbitcoins
# coincheckjpy
# bitfinexusd
# bitflyerjpy
# bitstampusd
# zaifjpy
# geminiusd
# korbit
# okcoincny
# lakeusd
# wexusd
# btcboxjpy
# coinsbankeur
# coinsbankrub
# hitbtcusd
# cexusd
# cexiousd
# bitstampeur
# coinsbankusd
# coinsbankgbp
# oitbitusd
# getbtcusd
# okcoinusd
# btcoididr
# coinfloorgbp
# Bitstamp
# Bitcoin Charts - https://bitcoincharts.com/markets/list/
# Bitpay
# BitcoinAverage
#
# This is bitcoinaverage.com
# Bitfinex
# Bitstamp
# Gemini
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
    [Markets::Bitfinex].each do |market|
      threads << Thread.new do
        market.new(repo: repo).start
      end
    end

    threads.each(&:join)
  end
end
