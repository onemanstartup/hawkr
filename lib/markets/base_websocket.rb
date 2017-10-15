# frozen_string_literal: true

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

    # Should return ruby object that have method to_json
    # Possible objects Array and Hash
    def send_on_open; end

    def parse(msg)
      return unless valid_message?(msg)
      save_item(represented(msg))
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
      Thread.new do
        loop do
          EM.run do
            ws = WebSocket::EventMachine::Client.connect(uri: feed_url, ssl: ssl?)
            puts 'ws connection'
            puts 'send'

            ws.onopen do
              puts 'Connected'
              if send_on_open
                if send_on_open.is_a?(Array)
                  send_on_open.each do |message|
                    ws.send(message.to_json)
                  end
                else
                  ws.send(send_on_open.to_json)
                end
              end
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
