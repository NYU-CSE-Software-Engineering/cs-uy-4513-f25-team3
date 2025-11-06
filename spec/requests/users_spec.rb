require 'rails_helper'

RSpec.describe "User logout", type: :request do

    #function to stup login and logout since sessions are not implemented yet
    #this should be removed once login is functioning
    def stub_user(user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    describe "DELETE /logout" do
        context "the user is logged in" do
            before do
                stub_user(double("User", id: 3)) #stubbing login
            end

            it "prevents access to protected pages after logout" do
                delete logout_path
                stub_user(nil) #stubbing logout since sessions don't exist yet, will happen in destroy path, code is there
                get itineraries_path # visit a protected page (should be denied access)
                expect(response).to redirect_to(login_path) # when access is denied it redirects to login page
            end

            it "redirects to the login page" do
                delete logout_path 
                expect(response).to redirect_to(login_path) #logging out redirects to the login page
            end
        end

        context "the user is already logged out" do
            before do
               stub_user(nil)
            end
            it "redirects to the login page" do
                delete logout_path
                expect(response).to redirect_to(login_path)
            end
            it "prevents access to protected pages" do
                get itineraries_path
                expect(response).to redirect_to(login_path)
            end
        end
    end
end