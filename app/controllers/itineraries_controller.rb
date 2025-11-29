class ItinerariesController < ApplicationController
  before_action :require_login

  def index
    @itineraries = ItineraryGroup.all

    # "Filters not applied until search triggered"
    return unless params[:commit] == "Search" && params[:clear].blank?

    if params[:clear].present?
      @itineraries = ItineraryGroup.all
      return
    end

    apply_search_filter
    return if handle_date_errors || handle_cost_errors

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

  def handle_date_errors
    return false if params[:start_date].blank? || params[:end_date].blank?

    start_date = Date.parse(params[:start_date]) rescue nil
    end_date   = Date.parse(params[:end_date])   rescue nil

    if start_date && end_date && end_date < start_date
      flash.now[:alert] = "End date must be after start date"
      @itineraries = base_scope.none
      true
    else
      false
    end
  end

  def handle_cost_errors
    min = params[:min_cost]
    max = params[:max_cost]

    return false if min.blank? && max.blank?

    numeric = ->(v) { v.to_s.match?(/\A\d+(\.\d+)?\z/) }

    unless [min, max].compact.all? { |v| numeric.call(v) }
      flash.now[:alert] = "Please enter valid numbers for cost"
      @itineraries = base_scope.none
      return true
    end

    false
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
    min = params[:min_cost].presence&.to_f
    max = params[:max_cost].presence&.to_f
    return if min.nil? && max.nil?

    @itineraries = @itineraries.where("cost >= ?", min) if min
    @itineraries = @itineraries.where("cost <= ?", max) if max
  end
end
