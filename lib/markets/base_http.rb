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

    def parse(msg)
      return unless valid_message?(msg)
      obj = representer.new(OpenStruct.new).from_json(msg)
      @repo.create(obj.to_h)
    end

    def representer
      Object.const_get(self.class.to_s + '::Representer')
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
  end
end
