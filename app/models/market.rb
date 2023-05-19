# frozen_string_literal: true

class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  def self.search_validations(state, name, city)
    # require 'pry'; binding.pry
    if city.present? && name.nil? && state.nil?
      raise ArgumentError
    elsif city.present? && name.present? && state.nil?
      raise ArgumentError
      # require 'pry'; binding.pry
    elsif state.present? && name.present? && city.present?
      Market.where('lower(state) LIKE ? AND lower(city) LIKE ? AND lower(name) LIKE ?', "%#{state.downcase}%",
                   "%#{city.downcase}%", "%#{name.downcase}%")
    elsif state.present? && city.present? && name.nil?
      Market.where('lower(state) LIKE ? AND lower(city) LIKE ?', "%#{state.downcase}%", "%#{city.downcase}%")
    elsif state.present? && name.present? && city.nil?
      Market.where('lower(state) LIKE ? AND lower(name) LIKE ?', "%#{state.downcase}%", "%#{name.downcase}%")
    elsif state.present? && name.nil? && city.nil?
      Market.where('lower(state) LIKE ?', "%#{state.downcase}%")
    else
      name.present? && state.nil? && city.nil?
      Market.where('lower(name) LIKE ?', "%#{name.downcase}%")
    end
  end
end
