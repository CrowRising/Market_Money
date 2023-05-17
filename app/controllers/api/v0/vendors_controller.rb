# frozen_string_literal: true

module Api
  module V0
    class VendorsController < ApplicationController
      def index
        market = Market.find(params[:market_id])
        render json: VendorSerializer.new(market.vendors)
      end

      def show
        render json: VendorSerializer.new(Vendor.find(params[:id]))
      end

      def create
        vendor = Vendor.create!(vendor_params)
        render json: VendorSerializer.new(vendor)
      end

      def update
        vendor = Vendor.update!(params[:id], vendor_params)
        render json: VendorSerializer.new(vendor)
      end

      private

      def vendor_params
        params.require(:vendor).permit(:name,
                                       :description,
                                       :contact_name,
                                       :contact_phone,
                                       :credit_accepted)
      end
    end
  end
end
