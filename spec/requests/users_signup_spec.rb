require 'rails_helper'

RSpec.describe "User sign up", type: :request do
  let!(:user) { FactoryBot.create(:user, username: "john123") }

  describe "POST /users" do
    context "with valid parameters" do
      it "creates a new user and redirects to dashboard" do
        post users_path, params: { 
          user: { 
            username: "freddy", 
            role: "user",
            password: "mypassword123", 
            password_confirmation: "mypassword123" 
          } 
        }

        expect(response).to redirect_to(itineraries_path)

        follow_redirect!
        expect(response.body).to include("Account created successfully")
      end
    end

    context "with invalid parameters" do
      it "fails when username already taken" do
        post users_path, params: { 
          user: { 
            username: "john123", 
            role: "user",
            password: "pass123", 
            password_confirmation: "pass123"
          } 
        }

        expect(response).to render_template(:new)
        expect(response.body).to include("Username has already been taken")
      end

      it "fails when password confirmation does not match" do
        post users_path, params: { 
          user: { 
            username: "newuser", 
            role: "user",
            password: "goodpass", 
            password_confirmation: "WRONGpass" 
          } 
        }

        expect(response).to render_template(:new)
        text = CGI.unescapeHTML(response.body)
        expect(text).to include("Password confirmation does not match")
      end

      it "fails when required fields are missing" do
        post users_path, params: { user: { username: "", password: "", password_confirmation: "", role: "user" } }

        expect(response).to render_template(:new)
        text = CGI.unescapeHTML(response.body)
        expect(text).to include("Username can't be blank")
        expect(text).to include("Password can't be blank")
        expect(text).to include("Password confirmation can't be blank")
      end
    end
  end
end
