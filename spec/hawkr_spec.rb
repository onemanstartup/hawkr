# frozen_string_literal: true
require 'byebug'

RSpec.describe Hawkr do
  it 'has a version number' do
    expect(Hawkr::VERSION).not_to be nil
  end

  it 'does something useful' do
    @repo = RomBoot.new.tickers_repo
    tickers = @repo.markets.to_a
    representer = TickerRepresenter.new(tickers)
    # puts tickers.map { |a| a.time }
    # expect(tickers.count).to eq(33)
    expect(representer).to match_response
  end

  it 'returns json with every ticker' do
    @repo = RomBoot.new.tickers_repo
    tickers = @repo.markets.to_a
    representer = TickerRepresenter.new(tickers)

    representer.to_hash['tickers'].map do |t|
      unique_ticker = t.delete('unique_ticker')
      t.each_with_object([]) { |(k,v), m| m << { "#{unique_ticker}:#{k}".downcase.tr(':','_') => v } }
    end
    expect(representer).to match_response
  end
end
