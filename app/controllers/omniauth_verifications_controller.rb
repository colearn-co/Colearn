class OmniauthVerificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def verify_token_google

    render status: :forbidden unless params[:token]

    token = params[:token]
    response = HTTParty.get("https://www.googleapis.com/oauth2/v2/userinfo",
                            headers: {"Access_token"  => token,
                                      "Authorization" => "OAuth #{token}"})

    if response.code == 200
      data = JSON.parse(response.body)
      @user = User.find_for_verfied_token_response(data.symbolize_keys, "google_oauth2", token)
      sign_in(:user, @user)
      render :json => @user.to_json(:only => [:id, :name])
    else
      render :json => {:error => true}
    end
  end

  def verify_token_facebook

    render status: :forbidden unless params[:token]

    token = params[:token]
    
    response = HTTParty.get("https://graph.facebook.com/debug_token?input_token=#{token}&access_token=#{Constants::FB_APP_TOKEN}")
    
    puts response.body

    if response.code == 200
      data = JSON.parse(response.body)
      first_level_symb_data = data.symbolize_keys
      symbolized_data = first_level_symb_data[:data].symbolize_keys
      user_id = symbolized_data[:user_id]
      response = HTTParty.get("https://graph.facebook.com/#{user_id}?access_token=#{Constants::FB_APP_TOKEN}&fields=id,email,name,picture")

      if response.code == 200
        data = JSON.parse(response.body)
        picture_url = data["picture"]["data"]["url"]
        data["picture"] = picture_url
        @user = User.find_for_verfied_token_response(data.symbolize_keys, "facebook", token)        
        sign_in(:user, @user)
      	render :json => @user.to_json(:only => [:id, :name])
      else
        render :json => {:error => true}
      end
    else
      render :json => {:error => true}
    end
  end

  def verify_token_token
  	if params[:provider] == "google"
  		verify_token_google
  	else
  		verify_token_facebook  		
  	end
  end

end
