# frozen_string_literal: true

require_relative './base_http'

module Markets
  class Bithumb < BaseHttp
    def api_base
      'https://api.bithumb.com'
    end

    def api_url
      '/public/ticker/ALL'
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        save_item(coin)
      end
    end

    def prepare_json(json)
      json['data'].reduce([]) do |memo, value|
        next memo if %w[date].include?(value[0])
        memo << value[1]
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market, default: 'bithumb'
      property :currency
      property :ticker,     default: 'KWR'
      property :price,      as: :closing_price
      property :low_24h,    as: :min_price
      property :high_24h,   as: :max_price
      property :volume_24h, as: :volume_1day
      property :avg_24h, as: :average_price
    end
  end
end

# {
#     "status": "0000",
#     "data": {
#         "opening_price" : "504000",
#         "closing_price" : "505000",
#         "min_price"     : "504000",
#         "max_price"     : "516000",
#         "average_price" : "509533.3333",
#         "units_traded"  : "14.71960286",
#         "volume_1day"   : "14.71960286",
#         "volume_7day"   : "15.81960286",
#         "buy_price"     : "505000",
#         "sell_price"    : "504000",
#         "date"          : 1417141032622
#     }
# }
