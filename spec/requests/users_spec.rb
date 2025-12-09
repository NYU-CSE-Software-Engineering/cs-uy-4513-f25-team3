require 'rails_helper'

RSpec.describe "User login", type: :request do
  let!(:user) { FactoryBot.create(:user, username: "izzyadams11", password: "iloveCS123", password_confirmation: "iloveCS123") }
  
    describe "POST /login" do
        context "with valid credentials" do
            it "logs the user in and redirects to dashboard" do
                post login_path, params: { user: { username: user.username, password: user.password } }

                expect(response).to redirect_to(itineraries_path)
                follow_redirect!
                expect(response.body).to include("Welcome, #{user.username}")

            end
        end

        context "with invalid credentials" do
            it "doesn't log the user in and rerenders login page" do
                post login_path, params: { user: { username: user.username, password: "incorrect" } }


                expect(response).to render_template(:new)
                expect(response.body).to include("Invalid username and/or password")
            end
        end
    end
end


RSpec.describe "User logout", type: :request do
    let!(:user) { FactoryBot.create(:user, username: "izzyadams11", password: "iloveCS123", password_confirmation: "iloveCS123") }

    describe "DELETE /logout" do
        context "when the user is logged in" do
            before do
                post login_path, params: { user: { username: user.username, password: user.password } }
            end

            it "redirects to login and prevents access to protected pages after logout" do
                delete logout_path
                expect(response).to redirect_to(login_path)
                
                get itineraries_path
                expect(response).to redirect_to(login_path)

                follow_redirect!
                expect(response.body).to include("Login")
            end
        end

        context "when the user is already logged out" do
            before do
                delete logout_path
            end

            it "prevents access to protected pages" do
                get itineraries_path
                expect(response).to redirect_to(login_path)

                follow_redirect!
                expect(response.body).to include("Login")
            end

            it "redirects to the login page when user tries to logout" do
                delete logout_path
                expect(response).to redirect_to(login_path)

                follow_redirect!
                expect(response.body).to include("Login")
            end
        end
    end
end
