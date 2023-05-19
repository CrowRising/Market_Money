# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe '.search_validations' do
    before(:each) do
      @market = create(:market)
    end
    context 'when city is present and name/state are nil' do
      it 'raises ArgumentError' do
        expect { Market.search_validations(nil, nil, @market.city) }.to raise_error(ArgumentError)
      end
    end

    context 'when city and name are present and state is nil' do
      it 'raises ArgumentError' do
        expect { Market.search_validations(nil, @market.name, @market.city) }.to raise_error(ArgumentError)
      end
    end

    context 'when state, name, and city are present' do
      it 'returns markets matching the search criteria' do
        result = Market.search_validations(@market.state, @market.name, @market.city)
        expect(result).to eq([@market])
      end
    end
  end
end
