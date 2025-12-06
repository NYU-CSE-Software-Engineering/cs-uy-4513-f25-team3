class HotelsController < ApplicationController
  include SearchFilterable
  before_action :require_login
  skip_before_action :require_login, only: :index

  def index
    @hotels = Hotel.all

    if params[:clear].present?
      params[:search_location] = nil
      params[:start_date]      = nil
      params[:end_date]        = nil
      params[:min_cost]        = nil
      params[:max_cost]        = nil
      params[:min_rating]      = nil
      return
    end

    scope, date_error = handle_date_errors_for(Hotel)
    if date_error
      @hotels = scope
      return
    end

    scope, cost_error = handle_cost_errors_for(Hotel)
    if cost_error
      @hotels = scope
      return
    end

    apply_location_filter
    apply_rating_filter
    apply_cost_filter

    flash.now[:notice] = "No hotels found" if @hotels.empty? && flash.now[:alert].blank?
  end

  private

  def apply_location_filter
    return if params[:search_location].blank?

    location = "%#{params[:search_location].downcase}%"
    @hotels = @hotels.where("LOWER(location) LIKE ?", location)
  end

  def apply_rating_filter
    return if params[:min_rating].blank?

    min_rating = params[:min_rating].to_i
    @hotels = @hotels.where("rating >= ?", min_rating)
  end

  def apply_cost_filter
    @hotels = apply_cost_filter_for(@hotels)
  end
end
