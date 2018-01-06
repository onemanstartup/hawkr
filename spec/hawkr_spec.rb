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
    # result = representer.to_hash['tickers'].each_with_object({}) do |t, m|
    #   unique_ticker = t.delete('unique_ticker')
    #   market = t.each_with_object({}) { |(k,v), m| m["#{unique_ticker}:#{k}".downcase.tr(':','_')] = v }
    #   m.merge!(market)
    # end
    expect(representer).to match_response
  end
end
