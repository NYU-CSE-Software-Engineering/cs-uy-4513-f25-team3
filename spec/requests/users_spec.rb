require 'rails_helper'

RSpec.describe "User logout", type: :request do
    describe "DELETE /logout" do
        context "the user is logged in" do
            before do
                allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(double("User", id: 3)) #stubbing login
            end

            it "prevents access to protected pages" do
                delete logout_path
                get itineraries_path
                expect(response).to redirect_to(login_path)
            end

            it "redirects to the login page" do
                delete logout_path
                expect(response).to redirect_to(login_path)
            end
        end

        context "the user is logged out" do
            before do
                allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
            end
            it "redirects to the login page" do
                delete logout_path
                expect(response).to redirect_to(login_path)
            end
            it "prevents access to protected pages" do
                delete logout_path
                get itineraries_path
                expect(response).to redirect_to(login_path)
            end
        end
    end
end