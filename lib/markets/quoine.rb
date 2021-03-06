# frozen_string_literal: true

require_relative './base_http'

module Markets
  # https://developers.quoine.com
  # API users should not make more than 300 requests per 5 minute. Requests go beyond the limit will return with a 429 status
  # Have pusher channels?
  class Quoine < BaseHttp
    def api_base
      'https://api.quoine.com'
    end

    def headers
      { 'X-Quoine-API-Version' => '2' }
    end

    def api_url
      '/products'
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        begin
          save_item(coin)
        rescue => e
          # Some problems with eth:cny and eth:inr
          puts e
        end
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market, default: 'quoine'
      property :currency,   as: :base_currency
      property :ticker,     as: :quoted_currency
      property :price,      as: :last_traded_price
      property :bid,        as: :market_bid
      property :ask,        as: :market_ask
      property :low_24h,    as: :low_market_bid # ?
      property :high_24h,   as: :high_market_ask # ?
      property :volume_24h
    end
  end
end
