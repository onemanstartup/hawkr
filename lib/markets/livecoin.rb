# frozen_string_literal: true

# https://api.livecoin.net/exchange/ticker
# [{"cur":"USD","symbol":"USD/RUR","last":57.05001000,
# "high":57.75998000,"low":57.05001000,"volume":1308.71178133,
# "vwap":57.36350968,"max_bid":57.75998000,"min_ask":57.05001000,
# "best_bid":57.05001000,"best_ask":57.69929000}]

require_relative './base_http'

module Markets
  class Livecoin < BaseHttp
    def api_base
      'https://api.livecoin.net'
    end

    def api_url
      '/exchange/ticker'
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        save_item(coin)
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market,     default: 'livecoin'
      property :currency,   as: :cur
      property :ticker,     as: :symbol,
                            parse_filter: ->(fragment, _options) { fragment.gsub(%r{(.+)\/(.+)}, '\\2') }
      property :price,      as: :last
      property :bid,        as: :best_bid
      property :ask,        as: :best_ask
      property :low_24h,    as: :low
      property :high_24h,   as: :high
      property :avg_24h,    as: :vwap
      property :volume_24h, as: :volume
    end
  end
end
