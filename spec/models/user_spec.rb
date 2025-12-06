require 'rails_helper'

RSpec.describe User, type: :model do

    it 'is valid with username, password, and role' do
        user = User.new(username: "freddy", password: "pass123", password_confirmation: "pass123", role: "user")
        expect(user).to be_valid
    end

    it 'is invalid without a Username' do
        user = User.new(password: "abc123", role: "user")
        expect(user).not_to be_valid
    end
    it 'is invalid if Username already exists' do
        User.create!(username: "janey", password: "abc123", role: "user")
        duplicate = User.new(username: "janey", password: "pass123")
        expect(duplicate).not_to be_valid
    end
    it 'is invalid without a Password' do
        user = User.new(username: "john123", role: "user")
        expect(user).not_to be_valid
    end
    it 'is invalid without a role' do
        user = User.new(username: 'testuser', password: 'password123', password_confirmation: "password123")
        expect(user).not_to be_valid
    end

end

