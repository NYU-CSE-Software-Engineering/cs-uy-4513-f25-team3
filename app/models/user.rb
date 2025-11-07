class User < ApplicationRecord
  validates :role, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
end

