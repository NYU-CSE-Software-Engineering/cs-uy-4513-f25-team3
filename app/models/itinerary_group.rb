class ItineraryGroup < ApplicationRecord
  validates :title, presence: true
  validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :chronological_dates
  validate :dates_not_in_past

  def chronological_dates
    return if start_date.blank? || end_date.blank?
    if end_date < start_date
      errors.add(:end_date, "must be same as or after start date")
    end
  end

  def dates_not_in_past
    current = Date.current
    if start_date.present? && start_date < current
      errors.add(:start_date, 'start date must be today or in the future')
    end
    if end_date.present? && end_date < current
      errors.add(:end_date, 'end date must be today or in the future')
    end
  end

  def trip_type
    is_private? ? "Private" : "Public"
  end

  def trip_type=(value)
    self.is_private = value.to_s.casecmp("Private").zero?
  end
end
