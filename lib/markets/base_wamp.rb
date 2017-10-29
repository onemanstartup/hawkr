# frozen_string_literal: true

require 'wamp_client'

module Markets
  class BaseWamp
    def initialize(repo:)
      @repo = repo
    end

    def feed_url
      raise NotImplementedError
    end

    def subscription_topic
      raise NotImplementedError
    end

    def ssl?
      true
    end

    def valid_message?(_)
      true
    end

    # Should return ruby object that have method to_json
    # Possible objects Array and Hash
    def send_on_open; end

    def parse(msg)
      return unless valid_message?(msg)
      save_item(represented(prepare(msg)))
    end

    def prepare(msg)
      msg
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
      # Thread.new do
        # loop do
          puts 'trying to connect'
          wamp = WampClient::Connection.new(uri: feed_url, realm: 'realm1', verbose: false)

          wamp.on_join do |session, details|
            puts 'Session Open'
            handler = lambda do |args, kwargs, details|
              parse(args)
            end
            session.subscribe(subscription_topic, handler)
          end
          wamp.on_connect do
            puts 'Connect'
          end
          wamp.on_leave do |reason, details|
            puts "Left with reason: #{reason}"
          end
          wamp.on_disconnect do |reason|
            puts "Disconnected with reason: #{reason}"
          end
          wamp.on_challenge do |authmethod, extra|
            puts 'Challenge'
          end

          puts 'Trying to open'
          wamp.open
          puts 'SHould not happen'
        # end
      # end.join
    end
  end
end
