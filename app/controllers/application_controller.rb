class ApplicationController < ActionController::Base
  include Gravatarify::Helper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :store_current_location, :unless => :devise_controller?
  before_filter :track_user
  before_filter :auto_login
  before_filter :check_ui_version
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :referrer, :email, :username, :password, :password_confirmation, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :username, :login, :password, :remember_me])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :username, :password, :password_confirmation, :current_password])
  end

  def check_ui_version
    if !cookies[:uiv]
      if current_user || mobile_device?
        cookies[:uiv] = { value: Constants::UI_VERSIONS[:default], expires: 3.years.from_now } 
      else        
        cookies[:uiv] = { value: rand(10) < 2 ? Constants::UI_VERSIONS[:v1] : Constants::UI_VERSIONS[:default], 
          expires: 3.years.from_now }
      end
    elsif current_user
      cookies[:uiv] = { value: Constants::UI_VERSIONS[:default], expires: 3.years.from_now } 
    end
    prepare_views_path
  end

  def prepare_views_path
    prepend_view_path Rails.root + 'app' + "views_#{ui_version}" unless is_view_default?
  end

  def is_view_default?
    cookies[:uiv] == Constants::UI_VERSIONS[:default]
  end

  def is_view_v1?
    cookies[:uiv] == Constants::UI_VERSIONS[:v1]
  end

  def ui_version
    cookies[:uiv]
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
    cookies[:uid] = SecureRandom.base64(16) unless cookies[:uid]
    if !current_user && cookies[:referrer].blank?
      cookies[:referrer] = request.referer || "/"
    end
  end
end
