# frozen_string_literal: true

# https://www.bitstamp.net/api/
# https://www.bitstamp.net/api/v2/ticker/{currency_pair}/
# last 	Last BTC price.
# high 	Last 24 hours price high.
# low 	Last 24 hours price low.
# vwap 	Last 24 hours volume weighted average price.
# volume 	Last 24 hours volume.
# bid 	Highest buy order.
# ask 	Lowest sell order.
# timestamp 	Unix timestamp date and time.
# open 	First price of the day.

require_relative './base_http'

module Markets
  class Bitstamp < BaseHttp
    def api_base
      'https://www.bitstamp.net'
    end

    def api_url
      '/api/v2/ticker/'
    end

    def parse
      %w[btcusd btceur eurusd xrpusd xrpeur xrpbtc ltcusd ltceur ltcbtc ethusd etheur ethbtc'].each do |pair|
        coin = represented(parse_json(response: fetch(addon_url: pair)))
        currency, ticker = pair.scan(/.{3}/)
        coin.currency = currency
        coin.ticker = ticker
        save_item(coin)
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market,     default: 'bitstamp'
      property :currency,   default: ''
      property :ticker,     default: ''
      property :price,      as: :last
      property :bid,        as: :bid
      property :ask,        as: :ask
      property :low_24h,    as: :low
      property :high_24h,   as: :high
      property :avg_24h,    as: :vwap
      property :volume_24h, as: :volume
    end
  end
end
