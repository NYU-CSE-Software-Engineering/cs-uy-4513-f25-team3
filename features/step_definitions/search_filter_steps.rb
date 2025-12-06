When(/^I filter(?: (.*))? cost between (\d+) and (\d+)$/) do |unused, min, max|
  fill_in 'min_cost', with: min
  fill_in 'max_cost', with: max
  submit_search_form
end

When(/^I filter by dates between "([^"]*)" and "([^"]*)"$/) do |start_date, end_date|
  fill_in 'start_date', with: start_date
  fill_in 'end_date', with: end_date
  submit_search_form
end

When('I clear all filters') do
  click_button 'Clear'
end

When(/^I filter(?: (.*))? with an invalid cost range$/) do |unused|
  fill_in 'min_cost', with: 'abc'
  submit_search_form
end

Then('I should not see {string}') do |content|
  expect(page).not_to have_content(content)
end

def submit_search_form
  click_button "Search"
end