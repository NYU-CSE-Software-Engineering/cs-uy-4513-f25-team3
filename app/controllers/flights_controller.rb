class FlightsController < ApplicationController
  include SearchFilterable
  before_action :require_login
  skip_before_action :require_login, only: :index

  def index
    @flights = Flight.all

    if params[:clear].present?
      params[:departure_location] = nil
      params[:arrival_location]   = nil
      params[:start_date]         = nil
      params[:end_date]           = nil
      params[:min_cost]           = nil
      params[:max_cost]           = nil
      return
    end

    scope, date_error = handle_date_errors_for(Flight)
    if date_error
      @flights = scope
      return
    end

    scope, cost_error = handle_cost_errors_for(Flight)
    if cost_error
      @flights = scope
      return
    end

    apply_departure_filter
    apply_arrival_filter
    apply_cost_filter


  end

  private

  def apply_departure_filter
    return if params[:departure_location].blank?

    departure = "%#{params[:departure_location].downcase}%"
    @flights = @flights.where("LOWER(departure_location) LIKE ?", departure)
  end

  def apply_arrival_filter
    return if params[:arrival_location].blank?

    arrival = "%#{params[:arrival_location].downcase}%"
    @flights = @flights.where("LOWER(arrival_location) LIKE ?", arrival)
  end

  def apply_cost_filter
    @flights = apply_cost_filter_for(@flights)
  end
end
