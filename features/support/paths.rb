# path helpers
def path_to(page_name)
    page_name = page_name.delete('"')
    case page_name
    when "login"
        login_path
    when "itineraries"
        itineraries_path
    else
        raise "No path mapping for '#{page_name}'"
    end

end
