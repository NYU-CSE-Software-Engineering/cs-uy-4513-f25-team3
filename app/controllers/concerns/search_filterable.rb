module SearchFilterable
  extend ActiveSupport::Concern

  private

  def handle_date_errors_for(scope_class)
    start_param = params[:start_date]
    end_param   = params[:end_date]

    return [scope_class.all, false] if start_param.blank? && end_param.blank?

    start_date = start_param.present? ? (Date.parse(start_param) rescue nil) : nil
    end_date   = end_param.present?   ? (Date.parse(end_param)   rescue nil) : nil

    if (start_param.present? && start_date.nil?) ||
      (end_param.present? && end_date.nil?)
      flash.now[:alert] = "Please enter valid dates"
      return [scope_class.none, true]
    end

    if start_date && end_date && end_date < start_date
      flash.now[:alert] = "End date must be after start date"
      return [scope_class.none, true]
    end

    [scope_class.all, false]
  end


  def handle_cost_errors_for(scope_class)
    min = params[:min_cost]
    max = params[:max_cost]

    return [scope_class.all, false] if min.blank? && max.blank?

    numeric = ->(v) { v.to_s.match?(/\A\d+(\.\d+)?\z/) }

    values_to_check = [min, max].reject(&:blank?)

    unless values_to_check.all? { |v| numeric.call(v) }
      flash.now[:alert] = "Please enter valid numbers for cost"
      return [scope_class.none, true]
    end

    [scope_class.all, false]
  end

  def apply_cost_filter_for(relation)
    min_param = params[:min_cost]
    max_param = params[:max_cost]

    return relation if min_param.blank? && max_param.blank?

    min = min_param.present? ? min_param.to_f : 0.0
    max = max_param.present? ? max_param.to_f : nil

    relation = relation.where("cost >= ?", min)
    relation = relation.where("cost <= ?", max) if max
    relation
  end
end
