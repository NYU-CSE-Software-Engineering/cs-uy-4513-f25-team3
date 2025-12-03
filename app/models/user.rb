class User < ApplicationRecord
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
end

