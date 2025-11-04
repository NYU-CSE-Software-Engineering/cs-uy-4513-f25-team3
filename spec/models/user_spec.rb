require 'rails_helper'

RSpec.describe User, type: :model do
    it 'is invalid without a Username' do
        user = User.new(password: "abc123")
        expect(user).not_to be_valid
    end
end