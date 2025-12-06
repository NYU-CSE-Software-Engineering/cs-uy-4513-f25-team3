require 'rails_helper'

RSpec.describe "User login", type: :request do
  let!(:user) { FactoryBot.create(:user, username: "izzyadams11", password: "iloveCS123") }
  
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
    let!(:user) { FactoryBot.create(:user, username: "izzyadams11", password: "iloveCS123") }

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


RSpec.describe "View Accounts", type: :request do
    let!(:user) { FactoryBot.create(:user, username: "izzyadams11", password: "iloveCS123") }
    let!(:admin) { FactoryBot.create(:admin, username: "adminTest", password: "iloveCS123") }
    describe "GET /accounts" do
        context "when the admin is logged in" do
            before do
                post login_path, params: { user: { username: admin.username, password: admin.password } }
            end

            it "shows the admin a list of all of the system accounts" do
                get accounts_path
                expect(response).to have_http_status(:ok)
                
                expect(response.body).to include(user.username)
                expect(response.body).not_to include(admin.username)  # shouldn't see self 

            end
        end

        context "when the user is logged in" do
            before do
                post login_path, params: { user: { username: user.username, password: user.password } }
            end

            it "denies access to the user and redirects to the itinerarie page" do
                get accounts_path
                expect(response).to redirect_to(itineraries_path)
                follow_redirect!
                expect(response.body).to include("Access Denied")

            end
        end
    end

    describe "DELETE /accounts" do
        context "admin deletes an existing account" do
            before do
                post login_path, params: { user: { username: admin.username, password: admin.password } }
            end
            it "removes the user from the system" do
                expect(User.exists?(user.id)).to be true
                delete accounts_path(user.id)
                expect(User.exists?(user.id)).to be false
                expect(response).to redirect_to(accounts_path)
                follow_redirect!
                expect(response.body).to include("Account deleted")
            end
        end
        context "admin deletes a nonexisting account" do
            before do
                post login_path, params: { user: { username: admin.username, password: admin.password } }
            end
            it "shows an error and takes no action" do
                fake_id = 100000
                expect(User.exists?(fake_id)).to be false
                expect {
                    delete accounts_path(fake_id)
                }.not_to change(User, :count)
                expect(response).to redirect_to(accounts_path)
                follow_redirect!
                expect(response.body).to include("Account does not exist")
            end
        end
        context "user tries to delete an account" do
            before do
                post login_path, params: { user: { username: user.username, password: user.password } }
            end
            it "says access denied and redirects to the itineraries page" do
                expect(User.exists?(user.id)).to be true
                delete accounts_path(user.id)
                expect(User.exists?(user.id)).to be true
                expect(response).to redirect_to(itineraries_path)
                follow_redirect!
                expect(response.body).to include("Access Denied")
            end
        end

    end

    describe "PUT /accounts" do
        context "admin changes an account type" do
            before do
                post login_path, params: { user: { username: admin.username, password: admin.password } }
            end
            it "changes the account type of the user" do
                expect(user.role).to eq("user")
                put accounts_path(user.id), params: { user: { role: "organizer" } }
                user.reload
                expect(user.role).to eq("organizer")
                expect(response).to redirect_to(accounts_path)
                follow_redirect!
                expect(response.body).to include("Account role updated successfully")

            end
        end

        context "user attempts to change account type" do
            before do
                post login_path, params: { user: { username: user.username, password: user.password } }
            end
            it "says access denied and redirects to the itineraries page" do
                expect(user.role).to eq("user")
                put accounts_path(admin.id), params: { user: { role: "organizer" } }
                admin.reload
                expect(admin.role).to eq("admin")
                expect(response).to redirect_to(itineraries_path)
                follow_redirect!
                expect(response.body).to include("Access Denied")
            end
        end

        context "admin chooses invalid role type" do
            before do
                post login_path, params: { user: { username: admin.username, password: admin.password } }
            end
            it "says invalid role type and doesn't affect the user type" do
                expect(user.role).to eq("user")
                put accounts_path(user.id), params: { user: { role: "superadmin" } }
                user.reload
                expect(user.role).to eq("user")
                expect(response).to redirect_to(accounts_path)

                follow_redirect!
                expect(response.body).to include("Invalid role type")

            end
        end
    end

end
