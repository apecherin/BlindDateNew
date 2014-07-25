class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:nickname, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:email, :password, :remember_me, :current_password)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:nickname, :email, :password, :password_confirmation, :sex, :description, :age, :avatar, :current_password)}
  end

end
