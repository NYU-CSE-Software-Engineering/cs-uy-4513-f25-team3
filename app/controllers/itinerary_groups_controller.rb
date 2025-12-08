class ItineraryGroupsController < ApplicationController

  def new
    @itinerary_group = ItineraryGroup.new
  end

  def edit
    @itinerary_group = ItineraryGroup.find(params[:id])
  end
  
  def update
    @itinerary_group = ItineraryGroup.find(params[:id])
    
    if @itinerary_group.update(itinerary_group_params)
      flash[:notice] = "Itinerary was successfully updated."
      redirect_to itinerary_path(@itinerary_group)
    else
      render :edit
    end
  end
  
  def show
    @itinerary_group = ItineraryGroup.find(params[:id])

    if @itinerary_group.is_private
        flash[:alert] = "This itinerary is private and cannot be viewed."
    end
  end

  def join
    @itinerary_group = ItineraryGroup.find(params[:id])
  end
  
  def join_itinerary
    @itinerary_group = ItineraryGroup.find(params[:id])
    if @itinerary_group.is_private && params[:password] != @itinerary_group.password
      flash[:alert] = "Incorrect trip password."
      render :join
    else
      flash[:notice] = "You have joined the trip successfully."
      redirect_to itinerary_path(@itinerary_group)
    end
  end
  
  private
  
  def itinerary_group_params
    params.require(:itinerary_group).permit(
      :title, :description, :location, 
      :start_date, :end_date,
      :is_private, :password)
  end
end