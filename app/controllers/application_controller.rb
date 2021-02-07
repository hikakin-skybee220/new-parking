class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?

    def pay_alert
        if current_user
            @non_pay_user = Park.find_by(user_id: current_user.id , finish_stamp: "no")
            @non_pay_reserve_user = Reserve.find_by(user_id: current_user.id , price_stamp: "no")
        end
    end

    protected

    def configure_permitted_parameters
        added_attrs = [ :email, :name, :password, :password_confirmation ]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs
        devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    end

    
end
