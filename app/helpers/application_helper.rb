module ApplicationHelper
    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end
    def bootstrap_class_for_flash(flash_type)
        case flash_type.to_sym
        when :notice then "success"
        when :alert  then "danger"
        else "info"
        end
    end

end
