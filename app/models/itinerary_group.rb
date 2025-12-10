class ItineraryGroup < ApplicationRecord
  # Associations
  # organizer ID
  belongs_to :organizer, class_name: "User", optional: true 

  has_many :itinerary_attendees, dependent: :destroy
  has_many :users, through: :itinerary_attendees

  has_many :itinerary_flights, dependent: :destroy
  has_many :flights, through: :itinerary_flights

  has_many :itinerary_hotels, dependent: :destroy
  has_many :hotels, through: :itinerary_hotels

  has_many :messages, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :end_date_not_before_start

  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :password, presence: true, if: :is_private?

  has_many :itinerary_attendees, dependent: :destroy
  has_many :attendees, through: :itinerary_attendees, source: :user
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id', optional: true

  def trip_type
    is_private? ? "Private" : "Public"
  end

  def trip_type=(value)
    self.is_private = value.to_s.casecmp("Private").zero?
  end

  private

  def end_date_not_before_start
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "cannot be before start_date") if end_date < start_date
  end
end
