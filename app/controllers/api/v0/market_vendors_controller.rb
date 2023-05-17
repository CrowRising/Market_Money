module Api
  module V0
    class MarketVendorsController < ApplicationController
      def create
        market_vendor = MarketVendor.create(params[:id])
        render json: MarketVendorSerializer.new(market_vendor)
      end
    end
  end
end