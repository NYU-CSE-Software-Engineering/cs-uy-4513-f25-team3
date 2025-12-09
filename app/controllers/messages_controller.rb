class MessagesController < ApplicationController
  before_action :set_itinerary_group, only: [:index, :create]
  before_action :ensure_group_membership, only: [:index, :create]

  def index
    @messages = @itinerary_group.messages.order(time: :asc)
  end

  def create
    text  = params[:text].to_s

    unless text.strip.empty?
      begin
        if session[:simulate_message_failure]
          raise ActiveRecord::ActiveRecordError, "Simulated failure"
        end

        Message.create!(
          user_id:            session[:user_id],
          itinerary_group_id: @itinerary_group.id,
          text:               text,
          time:               Time.current
        )
      rescue ActiveRecord::ActiveRecordError
        flash[:alert] = "Unable to send"
        flash[:failed_text] = text
      ensure
        session.delete(:simulate_message_failure)
      end
    end

    redirect_to itinerary_group_messages_path(@itinerary_group)
  end

  def update
    message = Message.find(params[:id])

    if message.user_id == session[:user_id]
      new_text = params[:text].to_s
      message.update!(text: new_text) unless new_text.strip.empty?
    end

    redirect_to itinerary_group_messages_path(message.itinerary_group_id)
  end

  private

  def set_itinerary_group
    group_id = params[:itinerary_group_id] || params[:id]
    @itinerary_group = ItineraryGroup.find(group_id)
  end

  def ensure_group_membership
    return if current_user.nil?
    return if @itinerary_group.organizer_id == current_user.id
    return if @itinerary_group.users.exists?(current_user.id)

    session[:pending_chat_group_id] = @itinerary_group.id
    flash[:alert] = "Join the trip to access its group chat."
    redirect_to join_itinerary_path(@itinerary_group)
  end
end
