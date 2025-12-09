class MessagesController < ApplicationController
  def index
    group_id = params[:itinerary_group_id] || params[:id]
    @itinerary_group = ItineraryGroup.find(group_id)
    @messages = @itinerary_group.messages.order(time: :asc)
  end

  def create
    group = ItineraryGroup.find(params[:id])
    text  = params[:text].to_s

    unless text.strip.empty?
      begin
        if session[:simulate_message_failure]
          raise ActiveRecord::ActiveRecordError, "Simulated failure"
        end

        Message.create!(
          user_id:            session[:user_id],
          itinerary_group_id: group.id,
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

    redirect_to itinerary_group_messages_path(group)
  end

  def update
    message = Message.find(params[:id])

    if message.user_id == session[:user_id]
      new_text = params[:text].to_s
      message.update!(text: new_text) unless new_text.strip.empty?
    end

    redirect_to itinerary_group_messages_path(message.itinerary_group_id)
  end
end
