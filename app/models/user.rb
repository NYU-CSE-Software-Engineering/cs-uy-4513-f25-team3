class User < ApplicationRecord
  has_secure_password
  has_many :messages

  has_many :itinerary_attendees, dependent: :destroy
  has_many :itinerary_groups, through: :itinerary_attendees
  has_many :organized_groups, class_name: 'ItineraryGroup', foreign_key: 'organizer_id', dependent: :destroy

  validates :role, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, unless: -> { provider.present? && uid.present? }
  validates :password_confirmation, presence: true, on: :create, unless: -> { provider.present? && uid.present? }
  validate  :passwords_match, on: :create, unless: -> { provider.present? && uid.present? }

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth.provider, uid: auth.uid).tap do |user|
      user.username = auth.info.email
      random_password = SecureRandom.hex(10)
      user.password = random_password
      user.password_confirmation = random_password
      user.role ||= "user"
      user.save! if user.new_record?
    end
  end

  def admin?
    role == "admin"
  end

  def organizer?
    role == "organizer"
  end

  def user?
    role == "user"
  end

  def oauth_user?
    provider.present?
  end


  private

  def passwords_match
    if password != password_confirmation
      errors.add(:password_confirmation, "Password confirmation does not match")
    end
  end
end
