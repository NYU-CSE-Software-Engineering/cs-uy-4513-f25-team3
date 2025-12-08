class Hotel < ApplicationRecord
  # Associations
  has_many :itinerary_hotels, dependent: :destroy
  has_many :itinerary_groups, through: :itinerary_hotels

  # Validations
  validates :name, presence: true
  validates :location, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1.0, less_than_or_equal_to: 5.0 }, allow_nil: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
