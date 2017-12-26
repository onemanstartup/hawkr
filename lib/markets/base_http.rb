# frozen_string_literal: true

module Markets
  class BaseHttp
    def initialize(repo:)
      @repo = repo
      @client = Faraday.new(url: api_base, headers: headers)
    end

    def prepare_ticker_request; end

    def headers; end

    def api_base
      raise NotImplementedError
    end

    def api_url
      '/'
    end

    def full_api_url
      api_base + api_url
    end

    def parse
      raise NotImplementedError
    end

    def parse_json(response: nil)
      JSON.parse((response || fetch).body)
    rescue JSON::JSONError => error
      # puts error
      # puts 'JSON parse error'
      raise error
    end

    def fetch(addon_url: '')
      prepare_ticker_request
      @client.get(api_url + addon_url)
    rescue Faraday::ClientError => error
      # TODO: Handle connection error
      # puts 'Connection Error'
      raise error
    end

    def fetch_json
      prepare_json(parse_json).to_json
    end

    def prepare_json(json)
      json
    end

    def represented_collection(json)
      representer.for_collection.new([]).from_json(json)
    end

    def represented(json)
      representer.new(OpenStruct.new).from_json(json)
    end

    def save_item(obj)
      hash = obj.to_h
      hash[:unique_ticker] = "#{obj.market}:#{obj.currency}:#{obj.ticker}"
      @repo.create(hash)
    end

    def representer
      Object.const_get(self.class.to_s + '::Representer')
    end

    # rubocop:disable all
    def start
      loop do
        begin
          parse
        rescue => ex
          puts ex.inspect
          puts ex.backtrace
        end
        puts 'waiting'
        sleep 59
      end
    end
  end
end
