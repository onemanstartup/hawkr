# frozen_string_literal: true

RSpec.describe Hawkr do
  it 'has a version number' do
    expect(Hawkr::VERSION).not_to be nil
  end

  it 'does something useful' do
    @repo = RomBoot.new.tickers_repo
    tickers = @repo.markets.to_a
    representer = TickerRepresenter.new(tickers)
    # puts tickers.map { |a| a.time }
    expect(tickers.count).to eq(33)
    expect(representer).to match_response
    puts representer.to_json
  end
end
