# frozen_string_literal: true

class MarketSerializer
  include JSONAPI::Serializer
  attributes :name,
             :street,
             :city,
             :county,
             :state,
             :zip,
             :lat,
             :lon

  attribute :vendor_count do |v|
    v.vendors.count
  end
end
