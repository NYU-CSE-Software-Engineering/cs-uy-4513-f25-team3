class User < ApplicationRecord

  validates :role, presence: true
end