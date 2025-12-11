require 'rails_helper'

RSpec.describe "ItineraryGroups", type: :request do
    let!(:user) do
        User.create!(
          username: "group_user",
          password: "password123",
          password_confirmation: "password123",
          role: "user"
        )
    end

    before do
        post login_path, params: { user: { username: user.username, password: "password123" } }
    end
    
    describe "GET /itineraries/:id" do
        let!(:organizer) do
            User.create!(
                username: 'alice', 
                password: 'pass123', 
                password_confirmation: 'pass123',
                role: 'organizer'
            )
        end
        let!(:itinerary_group) do
            ItineraryGroup.create!(
                title: "Europe Trip", 
                organizer_id: organizer.id,
                start_date: Date.today,
                end_date: Date.today + 7.days
            )
        end

        it "returns http success" do
            get itinerary_path(itinerary_group)
            expect(response).to have_http_status(:success)
        end

        it "assigns @itinerary_group" do
            get itinerary_path(itinerary_group)
            expect(assigns(:itinerary_group)).to eq(itinerary_group)
        end

        it "assigns @organizer" do
            get itinerary_path(itinerary_group)
            expect(assigns(:organizer)).to eq(organizer)
        end

        it "assigns @attendees" do
            member1 = User.create!(
                username: 'bob', 
                password: 'pass123',
                password_confirmation: 'pass123',
                role: 'user'
            )
            member2 = User.create!(
                username: 'carol', 
                password: 'pass123',
                password_confirmation: 'pass123',
                role: 'user'
            )
            ItineraryAttendee.create!(user: member1, itinerary_group: itinerary_group)
            ItineraryAttendee.create!(user: member2, itinerary_group: itinerary_group)
            
            get itinerary_path(itinerary_group)
            
            expect(assigns(:attendees)).to include(member1, member2)
        end
    end

    describe "GET /itineraries/:id/edit" do
        it "renders the edit template (settings page)" do
            itinerary_group = ItineraryGroup.create!(
                title: "NYC Tour",
                start_date: Date.today,
                end_date: Date.today + 1
            )

            get edit_itinerary_path(itinerary_group)
            
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:edit)
        end
    end


    describe "PATCH /itineraries/:id" do
        it "redirects to the show page after successful update" do
            itinerary_group = ItineraryGroup.create!(
                
                title: "NYC Tour",
                start_date: Date.today,
                end_date: Date.today + 1
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(response).to redirect_to(itinerary_path(itinerary_group))
        end

        it "sets a success flash message after successful update" do
            itinerary_group = ItineraryGroup.create!(
                
                title: "NYC Tour",
                start_date: Date.today,
                end_date: Date.today + 1
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(flash[:notice]).to eq("Itinerary was successfully updated.")
        end
    end
end

