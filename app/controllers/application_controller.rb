class ApplicationController < ActionController::Base
  include Gravatarify::Helper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   before_filter :configure_permitted_parameters, if: :devise_controller?
   before_filter :store_current_location, :unless => :devise_controller?
   before_filter :track_user
   before_filter :auto_login
    skip_before_action :verify_authenticity_token



  before_filter do
    # sign_in(:user, User.find(4))
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  protected


  def api_request?
    request.original_url.include?("/api/v")
  end

  def auto_login
    if !current_user && params[:uid] && params[:auth_key]
      u = User.find_by_id(params[:uid])
      if u && u.user_auth_key == params[:auth_key]      
        sign_in(:user, u)
        redirect_to url_for(params.except(:uid, :auth_key).merge(only_path: true))
      end
    end
  end

  def dummy_post_key
    RedisKeys::NEW_DUMMY_POST_INITIAL + cookies[:uid].to_s
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :referrer, :email, :password, :password_confirmation, :remember_me])
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
    if $redis.get(dummy_post_key)
      store_location_for(:user, new_post_url)
    else
      store_location_for(:user, request.url) unless request.xhr?
    end
  end

  def track_user
    cookies[:uid] = Digest::SHA256.digest(session.id || (Time.now.to_s + Devise.friendly_token[0,20].to_s)) unless cookies[:uid]
    if !current_user && cookies[:referrer].blank?
      cookies[:referrer] = request.referer || "/"
    end
  end
end
