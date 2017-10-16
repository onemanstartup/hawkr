# frozen_string_literal: true

require_relative './base_websocket'

module Markets
  # https://docs.gemini.com/websocket-api/#market-data
  class Gemini < BaseWebsocket
    # Multiple connections :(
    def feed_url
      'wss://api.gemini.com/v1/marketdata/:symbol'
    end

    def valid_message?(msg)
      JSON.parse(msg)['type'] == 'update'
    end

    class Representer < Representable::Decorator
      include Representable::JSON

      property :market,     default: 'gemini'
      property :currency,   as: :product_id,
                            parse_filter: ->(fragment, _options) { fragment.gsub(/(.+)-(.+)/, '\\1') }
      property :ticker,     as: :product_id,
                            parse_filter: ->(fragment, _options) { fragment.gsub(/(.+)-(.+)/, '\\2') }
      property :price
      property :bid,        as: :best_bid
      property :ask,        as: :best_ask
    end
  end
end
