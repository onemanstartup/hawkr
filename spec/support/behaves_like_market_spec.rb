# frozen_string_literal: true

shared_examples 'market' do
  subject(:market) { described_class.new(repo: RomBoot.test.tickers_repo) }

  let(:full_api_url) { market.full_api_url }

  it 'have api_url' do
    expect(market.api_url).not_to be_nil
  end

  it 'have api_base' do
    expect(market.api_base).not_to be_nil
  end

  it 'have right full_api_url' do
    expect(full_api_url).to eq(market.api_base + market.api_url)
  end

  it 'handles timeouts' do
    stub_request(:any, /#{market.api_base}/).to_timeout
    expect { market.fetch }.to raise_error(Faraday::ClientError)
  end

  it 'handles json garbage' do
    stub_request(:any, /#{market.api_base}/).to_return(body: 'garbage', status: 200)
    expect { market.parse_json }.to raise_error(JSON::JSONError)
  end
end
