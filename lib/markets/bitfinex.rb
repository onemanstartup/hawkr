# frozen_string_literal: true

require 'multi_json'
require_relative './base_websocket'

module Markets
  # https://bitfinex.readme.io/v2/docs/ws-general
  class Bitfinex < BaseWebsocket
    def pairs
      # Taken from theirs website
      # 0, 1, 19 is absent
      %w[ERROR
         ERROR BTCUSD LTCUSD LTCBTC ETHUSD
         ETHBTC ETCBTC ETCUSD RRTUSD RRTBTC
         ZECUSD ZECBTC XMRUSD XMRBTC DSHUSD
         DSHBTC BCCBTC BCUBTC ERROR BCCUSD
         BCUUSD XRPUSD XRPBTC IOTUSD IOTBTC
         IOTETH EOSUSD EOSBTC EOSETH SANUSD
         SANBTC SANETH OMGUSD OMGBTC OMGETH]
    end

    def feed_url
      'wss://api.bitfinex.com/ws/2'
    end

    def send_on_open
      @send_on_open ||=
        pairs.reduce([]) do |memo, value|
          memo << { event: 'subscribe',
                    channel: 'ticker',
                    symbol: value }
        end
    end

    # [
    #   5608.3,
    #   0,
    #   5608.4,
    #   0,
    #   -4.6,
    #   -0.0008,
    #   5607.3,
    #   43197.83418327,
    #   5877,
    #   5525.5
    # ]
    # [
    #   BID,
    #   BID_SIZE,
    #   ASK,
    #   ASK_SIZE,
    #   DAILY_CHANGE,
    #   DAILY_CHANGE_PERC,
    #   LAST_PRICE,
    #   VOLUME,
    #   HIGH,
    #   LOW
    # ]
    # BID	float	Price of last highest bid
    # BID_SIZE	float	Size of the last highest bid
    # ASK	float	Price of last lowest ask
    # ASK_SIZE	float	Size of the last lowest ask
    # DAILY_CHANGE	float	Amount that the last price has changed since yesterday
    # DAILY_CHANGE_PERC	float	Amount that the price has changed expressed in percentage terms
    # LAST_PRICE	float	Price of the last trade.
    # VOLUME	float	Daily volume
    # HIGH	float	Daily high
    # LOW	float	Daily low
    def parse(msg)
      parsed_json = MultiJson.load(msg)
      return unless parsed_json.is_a?(Array) && parsed_json[-1].is_a?(Array)
      data = parsed_json[-1]
      pair = pairs[parsed_json[0]]
      return if pair == 'ERROR'
      currency, ticker = pair.scan(/.{3}/)
      obj = OpenStruct.new(
        market: 'bitfinex',
        currency: currency,
        ticker: ticker,
        bid: data[0],
        ask: data[2],
        price: data[6],
        volume_24h: data[7],
        high_24h: data[8],
        low_24h: data[9]
      )
      save_item(obj.to_h)
    end
  end
end
