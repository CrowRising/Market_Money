require 'rails_helper'

describe 'market vendors api' do
  it 'can create market vendor' do
    create(:market, id: 1)
    create(:vendor, id: 1)

    post '/api/v0/market_vendors', params: { vendor_id: 1, market_id: 1 }

    market_vendor = MarketVendor.last
    mv = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
  end
end