# path helpers
def path_to(page_name)
    page_name = page_name.delete('"')
    case page_name
    when "login"
        login_path
    when "itineraries"
        itineraries_path
    when "flights"
        flights_path
    when "hotels"
        hotels_path
    when "profile edit page", "edit profile"
        edit_user_path(@user)
    when "new itinerary"
        new_itinerary_path
    else
        raise "No path mapping for '#{page_name}'"
    end
end
