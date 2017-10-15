# frozen_string_literal: true

require_relative './base_http'

module Markets
  class Coinone < BaseHttp
    def api_base
      'https://api.coinone.co.kr'
    end

    def api_url
      '/ticker?currency=all'
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        save_item(coin)
      end
    end

    def prepare_json(json)
      json.reduce([]) do |memo, value|
        next memo if %w[errorCode result timestamp].include?(value[0])
        memo << value[1]
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market, default: 'coinone'
      property :currency
      property :ticker,     default: 'KWR'
      property :price,      as: :last
      property :low_24h,    as: :low
      property :high_24h,   as: :high
      property :volume_24h, as: :volume
    end
  end
end
