class User < ApplicationRecord
  attr_accessor :password_confirmation
  has_many :messages

  validates :role, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
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
      errors.add(:password_confirmation, "doesn't match Password")
    end
  end
end