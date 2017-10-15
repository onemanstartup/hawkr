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

    def fetch
      @client.get api_url
    end

    def parse(msg)
      return unless valid_message?(msg)
      obj = represented(msg)
      @repo.create(obj.to_h)
    end

    def represented(json)
      representer.new(OpenStruct.new).from_json(json)
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
