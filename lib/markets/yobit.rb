
# frozen_string_literal: true

# https://yobit.net/en/api/
# {"ltc_btc":{"high":0.01179671,"low":0.0103697,"avg":0.0110832,"vol":12.15714119,"vol_cur":1099.32898829,"last":0.01162014,"buy":0.01162036,"sell":0.01170000,"updated":1508047961},"nmc_btc":{"high":0.00022061,"low":0.0002003,"avg":0.00021045,"vol":0.00953949,"vol_cur":47.29342753,"last":0.0002003,"buy":0.00020007,"sell":0.00021906,"updated":1508048176}}
# TODO: is it better to use their private websocket api?
# https://yobit.net/api/3/info list of pairs
# requests only for 50
require_relative './base_http'

module Markets
  class Yobit < BaseHttp
    def api_base
      'https://yobit.net'
    end

    def api_url
      '/api/3/ticker/ltc_btc-nmc_btc'
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        save_item(coin)
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market,     default: 'yobit'
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

#     high: maximal price
#     low: minimal price
#     avg: average price
#     vol: traded volume
#     vol_cur: traded volume in currency
#     last: last transaction price
#     buy: buying price
#     sell: selling price
#     updated: last cache upgrade
