class ItineraryGroupsController < ApplicationController
  def edit
    @itinerary_group = ItineraryGroup.find(params[:id])
  end
  def update
    @itinerary_group = ItineraryGroup.find(params[:id])
    
    if @itinerary_group.update(itinerary_group_params)
      flash[:notice] = "Itinerary was successfully updated."
      redirect_to itinerary_group_path(@itinerary_group)
    else
      render :edit
    end
  end
  
  def show
    @itinerary_group = ItineraryGroup.find(params[:id])
  end
  
  private
  
  def itinerary_group_params
    params.require(:itinerary_group).permit(:title)
  end
end