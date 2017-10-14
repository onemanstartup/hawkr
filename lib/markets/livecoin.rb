# https://api.livecoin.net/exchange/ticker
# [{"cur":"USD","symbol":"USD/RUR","last":57.05001000,
# "high":57.75998000,"low":57.05001000,"volume":1308.71178133,
# "vwap":57.36350968,"max_bid":57.75998000,"min_ask":57.05001000,
# "best_bid":57.05001000,"best_ask":57.69929000}]

module Markets
  class Livecoin
    def initialize(repo:)
      @repo = repo
      @ticker_url = '/exchange/ticker'
      @client = Faraday.new(url: 'https://api.livecoin.net')
    end

    def start
      Thread.new do
        loop do
          begin
            parse
          rescue => ex
            puts ex
          end
          puts 'waiting'
          sleep 59
        end
      end.join
    end

    def parse
      response = @client.get @ticker_url
      list = JSON.parse(response.body)
      list.each do |coin|
        obj = LivecoinTickerRepresenter.new(OpenStruct.new).from_json(coin.to_json)
        @repo.create(obj.to_h)
      end
    end

    class LivecoinTickerRepresenter < Representable::Decorator
      include Representable::JSON

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
