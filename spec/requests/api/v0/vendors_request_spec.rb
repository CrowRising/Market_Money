require 'rails_helper'

describe "vendors api" do
  it ' has a list of all vendors if valid id is entered' do
    @market_1 = create(:market)
    create_list(:vendor, 5, market_ids: @market_1.id, credit_accepted: true)

    get "/api/v0/markets/#{@market_1.id}/vendors"

    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendors.count).to eq(5)
    vendors.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)
      
      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes]).to have_key(:credit_accepted)
    end
  end

  it 'displays error message if invalid id is passed' do
    @market_1 = create(:market)
    create_list(:vendor, 5, market_ids: @market_1.id, credit_accepted: true)

    get "/api/v0/markets/3/vendors"

    expect(response).to_not be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(vendors).to eq({ "error": "Couldn't find Market with 'id'=3" })
  end

  it 'displays vendor and vendor attributes when valid id is passed' do
    @vendor_1 = create(:vendor)
    @vendor_2 = create(:vendor)

    get "/api/v0/vendors/#{@vendor_1.id}"
     expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendors[:attributes][:name]).to eq(@vendor_1.name)
    expect(vendors[:attributes][:description]).to eq(@vendor_1.description)
    expect(vendors[:attributes][:contact_name]).to eq(@vendor_1.contact_name)
    expect(vendors[:attributes][:contact_phone]).to eq(@vendor_1.contact_phone)
    expect(vendors[:attributes][:credit_accepted]).to eq(@vendor_1.credit_accepted)

    get "/api/v0/vendors/#{@vendor_2.id}"
     expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(vendors[:attributes][:name]).to eq(@vendor_2.name)
    expect(vendors[:attributes][:description]).to eq(@vendor_2.description)
    expect(vendors[:attributes][:contact_name]).to eq(@vendor_2.contact_name)
    expect(vendors[:attributes][:contact_phone]).to eq(@vendor_2.contact_phone)
    expect(vendors[:attributes][:credit_accepted]).to eq(@vendor_2.credit_accepted)
  end

  it 'displays error message if invalid id is passed' do
    @vendor_1 = create(:vendor)

    get "/api/v0/vendors/48555"

    expect(response).to_not be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)

    expect(vendors).to eq({ "error": "Couldn't find Vendor with 'id'=48555" })
  end

  it 'create a new vendor with attributes' do
    vendor_params = ({
      name: "Buzzy Bees",
      description: "local honey and wax products",
      contact_name: "Berly Couwer",
      contact_phone: "8389928383",
      credit_accepted: false
    })
    headers = {"CONTENT_TYPE" => "application/json"}
    post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)
    created_vendor = Vendor.last

    expect(response).to be_successful
    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end
end