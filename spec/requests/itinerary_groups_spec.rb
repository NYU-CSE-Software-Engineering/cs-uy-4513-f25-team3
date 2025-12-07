require 'rails_helper'

RSpec.describe "ItineraryGroups", type: :request do
    describe "GET /itinerary_groups/:id" do
        it "returns http success" do
            organizer = User.create!(username: 'alice', password: 'pass123', role: 'organizer')
            itinerary_group = ItineraryGroup.create!(title: "Europe Trip", organizer_id: organizer.id)
            
            get itinerary_group_path(itinerary_group)
            
            expect(response).to have_http_status(:success)
        end

        it "assigns @itinerary_group" do
            organizer = User.create!(username: 'alice', password: 'pass123', role: 'organizer')
            itinerary_group = ItineraryGroup.create!(title: "Europe Trip", organizer_id: organizer.id)
            
            get itinerary_group_path(itinerary_group)
            
            expect(assigns(:itinerary_group)).to eq(itinerary_group)
        end

        it "assigns @organizer" do
            organizer = User.create!(username: 'alice', password: 'pass123', role: 'organizer')
            itinerary_group = ItineraryGroup.create!(title: "Europe Trip", organizer_id: organizer.id)
            
            get itinerary_group_path(itinerary_group)
            
            expect(assigns(:organizer)).to eq(organizer)
        end

        it "assigns @attendees" do
            organizer = User.create!(username: 'alice', password: 'pass123', role: 'organizer')
            itinerary_group = ItineraryGroup.create!(title: "Europe Trip", organizer_id: organizer.id)
            member1 = User.create!(username: 'bob', password: 'pass123', role: 'user')
            member2 = User.create!(username: 'carol', password: 'pass123', role: 'user')
            ItineraryAttendee.create!(user: member1, itinerary_group: itinerary_group)
            ItineraryAttendee.create!(user: member2, itinerary_group: itinerary_group)
            
            get itinerary_group_path(itinerary_group)
            
            expect(assigns(:attendees)).to include(member1, member2)
        end
    end

    describe "GET /itineraries/:id/edit" do
        it "renders the edit template (settings page)" do
            itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
            
            get edit_itinerary_path(itinerary_group)
            
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:edit)
        end
    end


    describe "PATCH /itineraries/:id" do
        it "redirects to the show page after successful update" do
            itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(response).to redirect_to(itinerary_path(itinerary_group))
        end

        it "sets a success flash message after successful update" do
            itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(flash[:notice]).to eq("Itinerary was successfully updated.")
        end
    end
end