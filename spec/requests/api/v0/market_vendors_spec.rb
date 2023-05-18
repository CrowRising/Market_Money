# frozen_string_literal: true

require 'rails_helper'

describe 'market vendors api' do
  it 'can create market vendor' do
    market_1 = create(:market, id: 322_474)
    create(:vendor, id: 54_861, market_ids: market_1.id)

    MarketVendor.delete_all
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v0/market_vendors', headers:, params: JSON.generate(vendor_id: 54_861, market_id: 322_474)

    expect(response).to be_successful
    new_mk = MarketVendor.last
    expect(new_mk.market_id).to eq(322_474)
    expect(new_mk.vendor_id).to eq(54_861)

    new_market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(new_market_vendor).to eq({ "message": 'Successfully added vendor to market' })
  end

  it 'displays and error message if invalid market or vendor id is passed' do
    market_1 = create(:market, id: 322_474)
    create(:vendor, id: 54_861, market_ids: market_1.id)

    MarketVendor.delete_all
    headers = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/v0/market_vendors', headers:, params: JSON.generate(vendor_id: 53_331, market_id: 322_474)

    expect(response).to_not be_successful

    new_market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(new_market_vendor).to eq({ "error": 'Validation failed: Vendor must exist' })
  end

  it 'can destroy an existing market_vendor' do
    market_1 = create(:market, id: 322_474)
    vendor_1 = create(:vendor, id: 54_861)
    mkv = MarketVendor.create(market_id: market_1.id, vendor_id: vendor_1.id)

    expect(MarketVendor.find(mkv.id)).to eq(mkv)

    body = { market_id: market_1.id, vendor_id: vendor_1.id }
    delete '/api/v0/market_vendors', params: { market_vendor: body }

    expect(response).to be_successful
    expect(MarketVendor.count).to eq(0)
    expect(response.status).to eq(204)
    expect { MarketVendor.find(mkv.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'displays error message when market vendor cannot be found' do
    market_1 = create(:market, id: 322_474)
    vendor_1 = create(:vendor, id: 54_861)
    MarketVendor.create(market_id: market_1.id, vendor_id: vendor_1.id)

    body = { market_id: 4233, vendor_id: 11_520 }
    delete '/api/v0/market_vendors', params: { market_vendor: body }

    expect(response).to_not be_successful
    expect(response.status).to be(404)
    expect { MarketVendor.find(4233) }.to raise_error(ActiveRecord::RecordNotFound)
    expect { MarketVendor.find(11_520) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
