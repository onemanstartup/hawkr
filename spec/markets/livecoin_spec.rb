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
end
