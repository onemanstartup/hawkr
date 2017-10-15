# frozen_string_literal: true

require_relative '../spec_helper'

describe Markets::Bitstamp do
  subject(:market) { described_class.new(repo: RomBoot.test.tickers_repo) }

  it { is_expected.not_to be_nil }
  include_examples 'market'

  it 'returns 200 status' do
    VCR.use_cassette('bitstamp_http') do
      expect(market.fetch(addon_url: 'btcusd').status).to eq(200)
    end
  end

  it 'parses' do
    VCR.use_cassette('bitstamp_http') do
      response = market.fetch(addon_url: 'btcusd')
      json = market.parse_json(response: response).to_json
      expect(market.represented(json).ask).to eq('5500.00')
    end
  end
end
