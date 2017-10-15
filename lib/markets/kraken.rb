# frozen_string_literal: true

require_relative './base_http'

module Markets
  # https://www.kraken.com/en-us/help/api
  class Kraken < BaseHttp
    def api_base
      'https://api.kraken.com'
    end

    def api_url
      '/0/public/Ticker?pair=' + @api_url_params.to_s
    end

    def prepare_ticker_request
      return if @api_url_params
      response = @client.get '/0/public/AssetPairs'
      @api_url_params = JSON.parse(response.body)['result'].keys.join(',')
    end

    def parse
      represented_collection(fetch_json).each do |coin|
        save_item(coin)
      end
    end

    # KRAKEN IS ON CRACK
    def prepare_json(json)
      json['result'].reduce([]) do |memo, value|
        currency_ticker = value[0]
        currency, ticker = if currency_ticker.length == 8
                             currency_ticker.scan(/.{4}/)
                           else
                             currency_ticker.scan(/.{3}/)
                           end
        memo << value[1].merge(currency: currency, ticker: ticker)
      end
    end

    class Representer < Representable::Decorator
      include Representable::JSON
      collection_representer class: OpenStruct

      property :market, default: 'kraken'
      property :currency
      property :ticker
      property :price,      as: :c,
                            parse_filter: ->(fragment, _options) { fragment[0] }

      property :ask,        as: :a,
                            parse_filter: ->(fragment, _options) { fragment[0] }
      property :bid,        as: :b,
                            parse_filter: ->(fragment, _options) { fragment[0] }
      property :low_24h,    as: :l,
                            parse_filter: ->(fragment, _options) { fragment[1] }
      property :high_24h,   as: :h,
                            parse_filter: ->(fragment, _options) { fragment[1] }
      property :avg_24h,    as: :p,
                            parse_filter: ->(fragment, _options) { fragment[1] }
      property :volume_24h, as: :v,
                            parse_filter: ->(fragment, _options) { fragment[1] }
    end
  end
end

# a = ask array(<price>, <whole lot volume>, <lot volume>),
# b = bid array(<price>, <whole lot volume>, <lot volume>),
# c = last trade closed array(<price>, <lot volume>),
# v = volume array(<today>, <last 24 hours>),
# p = volume weighted average price array(<today>, <last 24 hours>),
# t = number of trades array(<today>, <last 24 hours>),
# l = low array(<today>, <last 24 hours>),
# h = high array(<today>, <last 24 hours>),
# o = today's opening price
