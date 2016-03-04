class HipchatConfigsController < ApplicationController

  def installed
    Rails.logger.info("-------params--installed--> #{params}")
    @installed = true
    if params.key? (:redirect_url)
      @roomId = get_room_id(params[:redirect_url])
    elsif params.key? (:room_id)
      @roomId = params[:room_id]
    else
      @installed = false  
    end  
  end

  def store
    Rails.logger.info("-------params--store--> #{params}")
    @h_conf = HipchatConfig.create_hipchat_config(params[:roomId], params[:oauthId], params[:oauthSecret])
  end

  def remove
    roomId = get_room_id(params[:redirect_url])
    h_config = HipchatConfig.find_by(room_id: roomId)
    if h_config
      h_config.destroy!
    end
    redirect_to hipchat_configs_installed_path
  end

  def send_test_message
    Rails.logger.info("----params[:room_id]----> #{params[:room_id]}") 
    h_cfg = HipchatConfig.find_by(room_id: params[:room_id])
    if h_cfg.nil?
      flash[:warning] = "No HipChat room connected!"
      redirect_to hipchat_configs_installed_path
    else  
      post_hipchat(h_cfg.token, '!!!test_message_vasa1!!!', h_cfg.room_id)
    end  
  end

  private

  def post_hipchat(token, message, room_id)
    json_data = {"color" => "green", "message" => message, "notify" => true, "message_format" => "html"}
    site = RestClient::Resource.new("https://api.hipchat.com/v2/room/#{room_id}/notification?auth_token=#{token}")
    response = site.post(json_data.to_json, :content_type => "application/json")
    flash[:success] = "Test message successfully sent!"
    redirect_to hipchat_configs_installed_path(:room_id => room_id)
  end

  def get_room_id(url)
    url.split("room=").last
  end

end
