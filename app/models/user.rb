class User < ApplicationRecord
  attr_accessor :password_confirmation
  has_many :messages

  validates :role, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  has_many :itinerary_attendees, dependent: :destroy
  has_many :itinerary_groups, through: :itinerary_attendees
  has_many :organized_groups, class_name: 'ItineraryGroup', foreign_key: 'organizer_id', dependent: :destroy
  def admin?
    role == "admin"
  end

  def organizer?
    role == "organizer"
  end

  def user?
    role =="user"
  end

  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validate  :passwords_match, on: :create

  private

  def passwords_match
    if password != password_confirmation
      errors.add(:password_confirmation, "Password confirmation does not match")
    end
  end
end