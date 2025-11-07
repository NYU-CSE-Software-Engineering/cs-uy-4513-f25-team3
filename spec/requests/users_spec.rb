require 'rails_helper'

RSpec.describe "User logout", type: :request do
    let!(:user) { User.create(username: "izzyadams11", password: "iloveCS123")} # create a fake user in database

    describe "DELETE /logout" do
        context "the user is logged in" do
            before do
                post login_path, params: {user_id: user.id} # login as user (needs full implementation later)
            end

            it "redirects to login and prevents access to protected pages after logout" do
                delete logout_path #logout
                expect(response).to redirect_to(login_path) #logging out redirects to the login page
                get itineraries_path # visit a protected page (should be denied access)
                expect(response).to redirect_to(login_path) # when access is denied it redirects to login page
            end

        end

        context "the user is already logged out" do
            before do
                delete logout_path # start logged out
            end
            it "prevents access to protected pages" do
                get itineraries_path
                expect(response).to redirect_to(login_path)
            end
            it "redirects to the login page when user tries to logout" do
                delete logout_path
                expect(response).to redirect_to(login_path)
            end
        end
    end
end