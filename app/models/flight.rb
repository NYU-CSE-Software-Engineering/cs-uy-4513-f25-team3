class Flight < ApplicationRecord
  # Associations
  has_many :itinerary_flights, dependent: :destroy
  has_many :itinerary_groups, through: :itinerary_flights

  # Validations
  validates :flight_number, presence: true
  validates :departure_location, presence: true
  validates :arrival_location, presence: true
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
