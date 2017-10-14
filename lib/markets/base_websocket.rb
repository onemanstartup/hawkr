module Markets
  class BaseWebsocket
    def initialize(repo:)
      @repo = repo
    end

    def feed_url
      raise NotImplementedError
    end

    def ssl?
      true
    end

    def valid_message?
      true
    end

    def send_on_open; end

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
          EM.run do
            ws = WebSocket::EventMachine::Client.connect(uri: feed_url, ssl: ssl?)
            puts 'ws connection'
            puts 'send'

            ws.onopen do
              puts 'Connected'
              ws.send(send_on_open) if send_on_open
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
  end
end
