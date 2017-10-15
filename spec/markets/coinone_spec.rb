# frozen_string_literal: true

require_relative '../spec_helper'

describe Markets::Coinone do
  subject(:market) { described_class.new(repo: RomBoot.test.tickers_repo) }

  it { is_expected.not_to be_nil }
  include_examples 'market'

  it 'returns 200 status' do
    VCR.use_cassette('coinone') do
      expect(market.fetch.status).to eq(200)
    end
  end

  it 'parses' do
    VCR.use_cassette('coinone') do
      response = market.fetch_json
      expect(market.represented_collection(response).size).not_to eq(0)
    end
  end
end
