# frozen_string_literal: true

require_relative './base_wamp'

module Markets
  class Poloniex < BaseWamp
    def feed_url
      'wss://api.poloniex.com'
    end

    def subscription_topic
      'ticker'
    end

    def prepare(msg)
      keys = %w[currencyPair last lowestAsk highestBid percentChange baseVolume quoteVolume isFrozen 24hrHigh 24hrLow]
      keys.zip(msg).to_h.to_json
    end

    class Representer < Representable::Decorator
      include Representable::JSON

      property :market,     default: 'poloniex'
      property :currency,   as: :currencyPair,
                            parse_filter: ->(fragment, _options) { fragment.gsub(/(.+)_(.+)/, '\\1') }
      property :ticker,     as: :currencyPair,
                            parse_filter: ->(fragment, _options) { fragment.gsub(/(.+)_(.+)/, '\\2') }
      property :price,      as: :last
      property :bid,        as: :highestBid
      property :ask,        as: :lowestAsk
      property :low_24h,    as: '24hrLow'
      property :high_24h,   as: '24hrHigh'
      property :volume_24h, as: :baseVolume
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
