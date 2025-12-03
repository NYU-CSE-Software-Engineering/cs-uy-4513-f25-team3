require 'rails_helper'

RSpec.describe User, type: :model do
    it 'is invalid without a Username' do
        user = User.new(password: "abc123")
        expect(user).not_to be_valid
    end
    it 'is invalid if Username already exists' do
        User.create!(username: "janey", password: "abc123", role: "user")
        duplicate = User.new(username: "janey", password: "pass123")
        expect(duplicate).not_to be_valid
    end
    it 'is invalid without a Password' do
        user = User.new(username: "john123")
        expect(user).not_to be_valid
    end
    it 'is invalid without a role' do
        user = User.new(username: 'testuser', password: 'password123')
        expect(user).not_to be_valid
    end
    it "returns true for admin? if role is admin" do
        user = create(:user, :admin)  
        expect(user.admin?).to be true
    end

    it "returns false for admin? if role is not admin" do
        user = create(:user, :organizer)  
        expect(user.admin?).to be false
    end

end