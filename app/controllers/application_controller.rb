class ApplicationController < ActionController::Base
  include Gravatarify::Helper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   before_filter :configure_permitted_parameters, if: :devise_controller?
   before_filter :store_current_location, :unless => :devise_controller?
  before_filter do
    # sign_in(:user, User.find(4))
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password])
  end

  def mobile_device?
    ( request.user_agent =~ /Mobile|webOS/ && (request.user_agent !~ /iPad/) )
  end
  helper_method :mobile_device?
  
  private
    # override the devise helper to store the current location so we can
    # redirect to it after loggin in or out. This override makes signing in
    # and signing up work automatically.
  def store_current_location
    store_location_for(:user, request.url) unless request.xhr?
  end
  protect_from_forgery with: :exception
end
