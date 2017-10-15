# frozen_string_literal: true

require_relative './base_http'

module Markets
  class Bter < BaseHttp
    def api_base
      'http://data.bter.com'
    end

    def api_url
      '/api2/1/tickers'
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        save_item(coin)
      end
    end

    def prepare_json(json)
      json.reduce([]) do |memo, value|
        currency, ticker = value[0].split('_')
        memo << value[1].merge(currency: currency, ticker: ticker)
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market, default: 'bter'
      property :currency
      property :ticker
      property :price,      as: :last
      property :ask,        as: :lowestAsk
      property :bid,        as: :highestBid
      property :low_24h,    as: :low24hr
      property :high_24h,   as: :high24hr
    end
  end
end
