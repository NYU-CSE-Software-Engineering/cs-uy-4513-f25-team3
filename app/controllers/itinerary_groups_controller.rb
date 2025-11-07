class ItineraryGroupsController < ApplicationController
  def edit
    @itinerary_group = ItineraryGroup.find(params[:id])
  end
end