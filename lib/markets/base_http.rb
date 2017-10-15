# frozen_string_literal: true

module Markets
  class BaseHttp
    def initialize(repo:)
      @repo = repo
      @client = Faraday.new(url: api_base)
    end

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

    def parse_json
      JSON.parse(fetch.body)
    rescue JSON::JSONError => error
      # puts error
      # puts 'JSON parse error'
      raise error
    end

    def fetch
      @client.get api_url
    rescue Faraday::ClientError => error
      # TODO: Handle connection error
      # puts 'Connection Error'
      raise error
    end

    def fetch_json
      fetch.body
    end

    def represented_collection(json)
      representer.for_collection.new([]).from_json(json)
    end

    def represented(json)
      representer.new(OpenStruct.new).from_json(json)
    end

    def save_item(obj)
      @repo.create(obj.to_h)
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
          puts ex
        end
        puts 'waiting'
        sleep 59
      end
    end
  end
end
