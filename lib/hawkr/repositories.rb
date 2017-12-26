# frozen_string_literal: true

require 'rom-repository'

module Hawkr
  class TickersRepo < ROM::Repository[:tickers]
    commands :create

    def query(conditions)
      tickers.where(conditions)
    end

    def all
      tickers
    end

    def markets
      tickers
        .read('
            SELECT unique_ticker,
                   last(price, time) as price,
                   last(bid, time) as bid,
                   last(ask, time) as ask,
                   last(low_24h, time) as low_24h,
                   last(high_24h, time) as high_24h,
                   last(avg_24h, time) as avg_24h,
                   last(volume_24h, time) as volume_24h,
                   last(volume_30d, time) as volume_30d
            FROM tickers
            GROUP BY unique_ticker;
         ')
      # .select { last(market, time).as(:market) }
      # .select { string::concat(market, ':', currency, ':', ticker).as(:market) }
      # .order(:time)
      # .distinct(:market, :currency, :ticker)
      # .group(:market, :currency, :ticker) #{ [market.qualified, currency.qualified, time.qualified, price.qualified, bid.qualified, ask.qualified, low_24h.qualified, high_24h.qualified, avg_24h.qualified, volume_24h.qualified, volume_30d.qualified] }
      # .max(:time)
      # .otder(:time)
      # .group([:market, :currency, :ticker]) { [time.qualified, price.qualified, bid.qualified, ask.qualified, low_24h.qualified, high_24h.qualified, avg_24h.qualified, volume_24h.qualified, volume_30d.qualified] }
      # .distinct(%i[market currency ticker])
    end
  end
end
