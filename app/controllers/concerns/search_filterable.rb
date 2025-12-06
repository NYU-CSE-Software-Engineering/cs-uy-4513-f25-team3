module SearchFilterable
  extend ActiveSupport::Concern

  private

  def handle_date_errors_for(scope_class)
    return [scope_class.all, false] if params[:start_date].blank? || params[:end_date].blank?

    start_date = Date.parse(params[:start_date]) rescue nil
    end_date   = Date.parse(params[:end_date])   rescue nil

    if start_date && end_date && end_date < start_date
      flash.now[:alert] = "End date must be after start date"
      [scope_class.none, true]
    else
      [scope_class.all, false]
    end
  end

  def handle_cost_errors_for(scope_class)
    min = params[:min_cost]
    max = params[:max_cost]

    return [scope_class.all, false] if min.blank? && max.blank?

    numeric = ->(v) { v.to_s.match?(/\A\d+(\.\d+)?\z/) }

    unless [min, max].compact.all? { |v| numeric.call(v) }
      flash.now[:alert] = "Please enter valid numbers for cost"
      [scope_class.none, true]
    else
      [scope_class.all, false]
    end
  end

  def apply_cost_filter_for(relation)
    min = params[:min_cost].presence&.to_f
    max = params[:max_cost].presence&.to_f
    return relation if min.nil? && max.nil?

    relation = relation.where("cost >= ?", min) if min
    relation = relation.where("cost <= ?", max) if max
    relation
  end
end

