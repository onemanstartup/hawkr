require 'rom-repository'

module Hawkr
  class TickersRepo < ROM::Repository[:tickers]
    commands :create
  end
end