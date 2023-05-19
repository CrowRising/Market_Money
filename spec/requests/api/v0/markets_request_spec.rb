# frozen_string_literal: true

require 'rails_helper'

describe 'markets api' do
  it ' has a list of all markets' do
    create_list(:market, 3)

    get '/api/v0/markets'
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    # require 'pry'; binding.pry
    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)

      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes]).to have_key(:lon)
    end
  end

  it 'has vendor count of each market' do
    # require 'pry'; binding.pry
    @market_1 = create(:market)
    @market_2 = create(:market)
    @market_3 = create(:market)
    create_list(:vendor, 4, market_ids: @market_1.id)
    create_list(:vendor, 2, market_ids: @market_2.id)
    create_list(:vendor, 3, market_ids: @market_3.id)

    get "/api/v0/markets/#{@market_1.id}"
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(markets[:attributes][:vendor_count]).to eq(4)
  end

  it 'has vendor count of each market' do
    @market_1 = create(:market)
    @market_2 = create(:market)
    @market_3 = create(:market)
    create_list(:vendor, 4, market_ids: @market_1.id)
    create_list(:vendor, 2, market_ids: @market_2.id)
    create_list(:vendor, 3, market_ids: @market_3.id)

    get "/api/v0/markets/#{@market_2.id}"
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(markets[:attributes][:vendor_count]).to eq(2)
  end

  it 'has vendor count of each market' do
    @market_1 = create(:market)
    @market_2 = create(:market)
    @market_3 = create(:market)
    create_list(:vendor, 4, market_ids: @market_1.id)
    create_list(:vendor, 2, market_ids: @market_2.id)
    create_list(:vendor, 3, market_ids: @market_3.id)

    get "/api/v0/markets/#{@market_3.id}"
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(markets[:attributes][:vendor_count]).to eq(3)
  end

  it 'displays all market attributes with valid market id' do
    @market_1 = create(:market)
    @market_2 = create(:market)
    @market_3 = create(:market)
    create_list(:vendor, 4, market_ids: @market_1.id)
    create_list(:vendor, 2, market_ids: @market_2.id)
    create_list(:vendor, 3, market_ids: @market_3.id)

    get "/api/v0/markets/#{@market_1.id}"
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(markets[:attributes][:name]).to eq(@market_1.name)
    expect(markets[:attributes][:street]).to eq(@market_1.street)
    expect(markets[:attributes][:city]).to eq(@market_1.city)
    expect(markets[:attributes][:county]).to eq(@market_1.county)
    expect(markets[:attributes][:state]).to eq(@market_1.state)
    expect(markets[:attributes][:zip]).to eq(@market_1.zip)
    expect(markets[:attributes][:lat]).to eq(@market_1.lat)
    expect(markets[:attributes][:lon]).to eq(@market_1.lon)
    # expect(markets[:attributes][:vendor_count]).to eq(4)
  end

  it 'displays error message if incorrect id is passed' do
    @market_1 = create(:market)
    create_list(:vendor, 4, market_ids: @market_1.id)

    get '/api/v0/markets/4050033'
    expect(response).to_not be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets).to eq({ "error": "Couldn't find Market with 'id'=4050033" })
  end
end

describe 'search markets api' do
  it 'can accept a certain combo of parameters' do
    market_1 = create(:market)
    get '/api/v0/markets/search', params: { state: market_1.state, name: market_1.name, city: market_1.city }

    expect(response).to be_successful
    expect(response.status).to eq(200)

    market = JSON.parse(response.body, symbolize_names: true)[:data].first

    expect(market[:id]).to eq(market_1.id.to_s)

    expect(market).to have_key(:attributes)
    expect(market[:attributes]).to be_a(Hash)

    expect(market[:attributes][:name]).to eq(market_1.name)
    expect(market[:attributes][:street]).to eq(market_1.street)
    expect(market[:attributes][:city]).to eq(market_1.city)
    expect(market[:attributes][:state]).to eq(market_1.state)
    expect(market[:attributes][:zip]).to eq(market_1.zip)
    expect(market[:attributes][:county]).to eq(market_1.county)
    expect(market[:attributes][:lat]).to eq(market_1.lat)
    expect(market[:attributes][:lon]).to eq(market_1.lon)
  end

  it 'displays an error message when only city is passed' do
    market = create(:market)
    get '/api/v0/markets/search', params: { city: market.city }

    expect(response).to_not be_successful
    expect(response.status).to eq(422)

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets).to eq({ "errors": [{ "detail": 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.' }] })
  end

  it 'displays an error message when only city and name is passed' do
    market = create(:market)
    get '/api/v0/markets/search', params: { name: market.name, city: market.city }

    expect(response).to_not be_successful
    expect(response.status).to eq(422)

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets).to eq({ "errors": [{ "detail": 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.' }] })
  end
end
