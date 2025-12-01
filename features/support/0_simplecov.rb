# Start SimpleCov ONLY if not already started by RSpec
if !defined?(SimpleCov::ResultMerger)
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "/spec/"
    add_filter "/features/"
  end
end
