require "active_support/testing/time_helpers"
World(ActiveSupport::Testing::TimeHelpers)

Before('@freeze_time_2025') do
  travel_to(Date.new(2025, 10, 1))
end

After('@freeze_time_2025') do
  travel_back
end
