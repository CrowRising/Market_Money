require 'rails_helper'

 describe "markets api" do
  it ' has a list of all markets' do
    create_list(:market, 3)

    get '/api/v0/markets'
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    
    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_an(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_an(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_an(String)
    end
  end

  it 'has vendor count of each market' do
    #require 'pry'; binding.pry
    @market_1 = create(:market)
    @market_2 = create(:market)
    @market_3 = create(:market)
    create_list(:vendor, 4, market_ids: @market_1.id)
    create_list(:vendor, 2, market_ids: @market_2.id)
    create_list(:vendor, 3, market_ids: @market_3.id)

    get "/api/v0/markets/#{@market_1.id}"
    expect(response).to be_successful

    # markets = JSON.parse(response.body, symbolize_names: true)
  end

 end