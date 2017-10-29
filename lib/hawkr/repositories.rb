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
  end
end
