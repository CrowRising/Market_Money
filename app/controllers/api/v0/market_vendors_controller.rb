# frozen_string_literal: true

module Api
  module V0
    class MarketVendorsController < ApplicationController
      def create
        market_vendor = MarketVendor.new(mk_params)

        if MarketVendor.where(params[:market_id] == :market_id && params[:vendor_id] == :vendor_id) != []
          render json: {
            "errors": [
              {
                "detail": "Validation failed: Market vendor asociation between market with market_id=#{params[:market_id]} and vendor_id=#{params[:vendor_id]} already exists"
              }
            ]
          }, status: 422
        elsif market_vendor.save
          render json: {
            "message": 'Successfully added vendor to market'
          }
        else
          render json: MarketVendorSerializer.new(MarketVendor.create!(mk_params))
        end
      end

      def destroy
        MarketVendor.find_by(market_id: mk_params[:market_id], vendor_id: mk_params[:vendor_id]).destroy

        # if market_vendor.nil?
        #   render_not_found_response(market_vendor)
        # else
        #   market_vendor.destroy
        #   render status: 204
        # end
      end

      private

      def mk_params
        params.require(:market_vendor).permit(:market_id, :vendor_id)
      end
    end
  end
end
