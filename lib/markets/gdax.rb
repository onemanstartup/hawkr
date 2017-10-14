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
module Markets
  class Gdax
    def initialize(repo:)
      @repo = repo
    end

    def subscription_message
      {
        type: 'subscribe',
        product_ids: [
          'ETH-USD',
          'BTC-USD',
          'LTC-USD'
        ],
        channels: %w[
          heartbeat
          ticker
        ]
      }.to_json
    end

    def start
      Thread.new do
        loop do
          EM.run do
            ws = WebSocket::EventMachine::Client.connect(uri: 'wss://ws-feed.gdax.com', ssl: true)
            puts 'ws connection'
            puts 'send'

            ws.onopen do
              puts 'Connected'
              ws.send(subscription_message)
            end

            ws.onmessage do |msg, _type|
              parse(msg)
            end

            ws.onclose do |code, _reason|
              puts "Disconnected with status code: #{code}"
            end
          end
        end
      end.join
    end

    def parse(msg)
      return if JSON.parse(msg)['type'] != 'ticker'
      obj = GdaxRepresenter.new(OpenStruct.new).from_json(msg)
      @repo.create(obj.to_h)
    end

    class GdaxRepresenter < Representable::Decorator
      include Representable::JSON

      property :market,     default: 'gdax'
      property :currency,   as: :product_id,
                            parse_filter: ->(fragment, _options) { fragment.gsub(%r{(.+)-(.+)}, '\\1') }
      property :ticker,     as: :product_id,
                            parse_filter: ->(fragment, _options) { fragment.gsub(%r{(.+)-(.+)}, '\\2') }
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
