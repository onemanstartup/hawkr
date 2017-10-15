# frozen_string_literal: true

shared_examples 'market' do
  subject(:market) { described_class.new(repo: RomBoot.test.tickers_repo) }

  it 'made request' do
    stub_request(:any, market.full_api_url)
    market.fetch
    expect(WebMock).to have_requested(:get, market.full_api_url)
  end

  it 'have api_url' do
    expect(market.api_url).not_to be_nil
  end

  it 'have api_base' do
    expect(market.api_base).not_to be_nil
  end

  it 'have right full_api_url' do
    expect(market.full_api_url).to eq(market.api_base + market.api_url)
  end
end
