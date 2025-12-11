class ItinerariesController < ApplicationController
  include SearchFilterable
  before_action :require_login
  
  # UNCOMMENT TO SEE THE ITINERARIES PAGE WITHOUT LOGIN AS IT IS NOT IMPLEMENTED YET
  # skip_before_action :require_login, only: :index 

  def index
    @itineraries = ItineraryGroup.all

    if params[:clear].present?
      params[:search]     = nil
      params[:start_date] = nil
      params[:end_date]   = nil
      params[:min_cost]   = nil
      params[:max_cost]   = nil
      params[:location]   = nil
      params[:trip_type]  = nil
      params[:membership] = nil
      return
    end

    apply_search_filter

    scope, date_error = handle_date_errors_for(ItineraryGroup)
    if date_error
      @itineraries = scope
      return
    end

    scope, cost_error = handle_cost_errors_for(ItineraryGroup)
    if cost_error
      @itineraries = scope
      return
    end

    apply_date_filter
    apply_location_filter
    apply_trip_type_filter
    apply_cost_filter
    apply_membership_filter

    flash.now[:notice] = "No itineraries found" if @itineraries.empty? && flash.now[:alert].blank?
  end

  private

  def base_scope
    ItineraryGroup.all
  end

  def apply_search_filter
    return if params[:search].blank?

    keyword = "%#{params[:search]}%"
    @itineraries = @itineraries.where(
      "LOWER(title) LIKE :kw OR LOWER(description) LIKE :kw", kw: keyword
    )
  end

  def apply_date_filter
    return if params[:start_date].blank? && params[:end_date].blank?

    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
    end_date   = params[:end_date].present?   ? Date.parse(params[:end_date])   : nil

    scope = @itineraries
    scope = scope.where("start_date >= ?", start_date) if start_date
    scope = scope.where("end_date <= ?", end_date)     if end_date
    @itineraries = scope
  end

  def apply_location_filter
    return if params[:location].blank?

    @itineraries = @itineraries.where("LOWER(location) LIKE ?", "%#{params[:location]}%")
  end

  def apply_trip_type_filter
    return if params[:trip_type].blank?

    private_flag = params[:trip_type].casecmp("Private").zero?
    @itineraries = @itineraries.where(is_private: private_flag)
  end

  def apply_cost_filter
    @itineraries = apply_cost_filter_for(@itineraries)
  end

  def apply_membership_filter
    return if params[:membership].blank?

    case params[:membership].downcase
    when "created"
      # itineraries where current_user is the creator
      @itineraries = @itineraries.where(organizer_id: current_user.id)
    when "joined"
      # itineraries where user is an attendee (through itinerary_attendees table)
      @itineraries = @itineraries.joins(:itinerary_attendees)
                               .where(itinerary_attendees: { user_id: current_user.id })
    when "none"
      # itineraries user did NOT join OR create
      created_ids = ItineraryGroup.where(organizer_id: current_user.id).select(:id)
      joined_ids  = ItineraryAttendee.where(user_id: current_user.id).select(:itinerary_group_id)

      @itineraries = @itineraries.where.not(id: created_ids).where.not(id: joined_ids)
    end
  end
end
