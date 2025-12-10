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
class ItineraryGroupsController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :require_organizer, only: [:edit, :update]
  rescue_from ActiveRecord::RecordNotFound, with: :group_not_found

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
    
    if @itinerary_group.is_private && !user_can_view_private_group?
      flash[:alert] = "This itinerary is private and cannot be viewed."
      @organizer = nil
      @attendees = []
    else
      @organizer = @itinerary_group.organizer
      @attendees = @itinerary_group.attendees
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
  
  def itinerary_group_params
    params.require(:itinerary_group).permit(:title, :is_private, :password)
  end

  def require_login
    unless session[:user_id]
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def user_can_view_private_group?
    return false unless session[:user_id]
    current_user = User.find_by(id: session[:user_id])
    return false unless current_user
    
    @itinerary_group.organizer_id == current_user.id || 
    @itinerary_group.attendees.include?(current_user)
  end

  def group_not_found
    flash.now[:alert] = "Group not found or doesn't exist."
    render plain: "Error: Group not found or doesn't exist.", status: :not_found
  end

  def require_organizer
    @itinerary_group = ItineraryGroup.find(params[:id])
    current_user = User.find_by(id: session[:user_id])
    
    unless current_user && @itinerary_group.organizer_id == current_user.id
      flash[:alert] = "You must be the organizer to edit this itinerary."
      redirect_to itinerary_group_path(@itinerary_group)
    end
  end
end
