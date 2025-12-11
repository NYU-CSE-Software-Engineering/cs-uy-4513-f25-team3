class ItineraryGroupsController < ApplicationController
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
    @can_view_private = can_view_itinerary?(@itinerary_group)

    if @itinerary_group.is_private && !@can_view_private
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
      unless @itinerary_group.users.exists?(current_user.id)
        @itinerary_group.users << current_user
      end
      flash[:notice] = "You have joined the trip successfully."
      if session[:pending_chat_group_id].to_i == @itinerary_group.id
        session.delete(:pending_chat_group_id)
        redirect_to itinerary_group_messages_path(@itinerary_group)
      else
        redirect_to itinerary_path(@itinerary_group)
      end
    end
  end
  
  private
  
  def can_view_itinerary?(itinerary_group)
    return true unless itinerary_group.is_private
    return false unless current_user

    itinerary_group.organizer_id == current_user.id ||
      itinerary_group.users.exists?(id: current_user.id)
  end

  def itinerary_group_params
    params.require(:itinerary_group).permit(:title, :is_private, :password)
  end
end
