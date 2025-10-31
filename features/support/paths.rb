def path_to(page_name)
  case page_name.downcase
  when 'home'
    root_path
  when 'login'
    login_path
  when 'profile'
    profile_path
  when 'new_itinerary'
    new_itinerary_path
  else
    raise "No mapping found for page name: #{page_name}"
  end
end
