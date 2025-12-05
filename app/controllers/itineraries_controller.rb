class ItinerariesController < ApplicationController
  include SearchFilterable
  before_action :require_login
  
  # UNCOMMENT TO SEE THE ITINERARIES PAGE WITHOUT LOGIN AS IT IS NOT IMPLEMENTED YET
  # skip_before_action :require_login, only: :index 

  def index
    @itineraries = ItineraryGroup.all

    # "Filters not applied until search triggered"
    return unless params[:commit] == "Search" && params[:clear].blank?

    if params[:clear].present?
      @itineraries = ItineraryGroup.all
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
    return if params[:start_date].blank? || params[:end_date].blank?

    start_date = Date.parse(params[:start_date])
    end_date   = Date.parse(params[:end_date])

    @itineraries = @itineraries.where(
      "start_date >= ? AND end_date <= ?", start_date, end_date
    )
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
end
