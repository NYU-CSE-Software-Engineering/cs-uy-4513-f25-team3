require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without a role' do
    user = User.new(username: 'testuser', password: 'password123')
    expect(user).not_to be_valid
  end
end