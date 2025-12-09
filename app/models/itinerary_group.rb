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
  validates :location, presence: {message: 'location field can not be blank'}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :chronological_dates
  validate :dates_not_in_past
  validate :private_password_check
  validates :cost,
    numericality: {
      only_integer: true,               
      message: 'must be an integer'     
    },
    allow_nil: true

  validates :cost,
    numericality: {              
      greater_than_or_equal_to: 0,
      message: 'must be greater or equal to 0'   
    },
    allow_nil: true

  validates :cost,
    numericality: {
      message:'is not a number'      
    },
    allow_nil: true


  def chronological_dates
    return if start_date.blank? || end_date.blank?
    if end_date < start_date
      errors.add(:base, "end_date must be after or the same as start_date")
    end
  end

  def dates_not_in_past
    return if start_date.blank? || end_date.blank?
      current = Date.current

    if start_date < current || end_date < current
      errors.add(:base, "start_date and end_date must be in the future")
    end
  end

  def private_password_check
    if is_private? && password.blank?
      errors.add(:password, 'required for private trips')
    end 
  end

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
