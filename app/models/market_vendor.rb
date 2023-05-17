# frozen_string_literal: true

class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor
end
