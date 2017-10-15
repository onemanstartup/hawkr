# frozen_string_literal: true

require_relative '../spec_helper'

describe Markets::Livecoin do
  subject(:market) { described_class.new(repo: RomBoot.test.tickers_repo) }

  it { is_expected.not_to be_nil }
  include_examples 'market'

  it 'returns 200 status' do
    VCR.use_cassette('livecoin') do
      expect(market.fetch.status).to eq(200)
    end
  end

  it 'parses' do
    VCR.use_cassette('livecoin') do
      response = market.fetch.body
      expect(market.represented_collection(response).size).not_to eq(0)
    end
  end

  # it 'save tickers' do
  #   VCR.use_cassette('livecoin') do
  #     expect(market.parse).to be_nil
  #   end
  # end
end
