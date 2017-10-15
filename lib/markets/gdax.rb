# frozen_string_literal: true

require_relative './base_websocket'

module Markets
  class Gdax < BaseWebsocket
    def feed_url
      'wss://ws-feed.gdax.com'
    end

    def send_on_open
      {
        type: 'subscribe',
        product_ids: ['ETH-USD', 'BTC-USD', 'LTC-USD'],
        channels: %w[heartbeat ticker]
      }
    end

    def valid_message?(msg)
      JSON.parse(msg)['type'] == 'ticker'
    end

    class Representer < Representable::Decorator
      include Representable::JSON

      property :market,     default: 'gdax'
      property :currency,   as: :product_id,
                            parse_filter: ->(fragment, _options) { fragment.gsub(/(.+)-(.+)/, '\\1') }
      property :ticker,     as: :product_id,
                            parse_filter: ->(fragment, _options) { fragment.gsub(/(.+)-(.+)/, '\\2') }
      property :price
      property :bid,        as: :best_bid
      property :ask,        as: :best_ask
      property :low_24h
      property :high_24h
      property :volume_24h
      property :volume_30d
    end
  end
end

# Ticker response
# {"type":"ticker",
# "sequence":4184632904,
# "product_id":"BTC-USD",
# "price":"4787.00000000",
# "open_24h":"4780.00000000",
# "volume_24h":"11791.36039581",
# "low_24h":"4787.00000000",
# "high_24h":"4925.65000000",
# "volume_30d":"379145.49027675",
# "best_bid":"4786.99",
# "best_ask":"4787",
# "side":"buy",
# "time":"2017-10-11T14:34:41.759000Z",
# "trade_id":21826060,
# "last_size":"0.00000208"}
