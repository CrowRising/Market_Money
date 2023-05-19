# frozen_string_literal: true

module Api
  module V0
    class MarketsController < ApplicationController
      def index
        # require 'pry'; binding.pry
        render json: MarketSerializer.new(Market.all)
      end

      def show
        render json: MarketSerializer.new(Market.find(params[:id]))
      end

      def search
        state = params[:state]
        name = params[:name]
        city = params[:city]

        begin
          search = Market.search_validations(state, name, city)
          render json: MarketSerializer.new(search), status: 200
        rescue ArgumentError
          render json: { "errors": [
            {
              "detail": 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.'
            }
          ] }, status: 422
        end
      end
    end
  end
end
