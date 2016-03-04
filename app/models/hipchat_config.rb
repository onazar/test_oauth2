require 'rest_client'

class HipchatConfig < ActiveRecord::Base
  class << self
    def create_hipchat_config(room_id, oauth_id, secret_key)
      h_cfg = HipchatConfig.find_by(room_id: room_id)

      if h_cfg.nil?
        h_cfg = HipchatConfig.new(room_id: room_id)
        h_cfg.token = get_access_token(oauth_id, secret_key)
        h_cfg.oauth_id = oauth_id
        h_cfg.oauth_secret = secret_key
        h_cfg.save!
      end
      h_cfg
    end

    private
    def get_access_token(oauth_id,secret_key)
      params = URI::encode("grant_type=client_credentials&scope=send_notification view_room")
      site = RestClient::Resource.new("https://api.hipchat.com/v2/oauth/token?#{params}",oauth_id,secret_key)
      response = site.post(:content_type=>"application/json")
      return JSON.parse(response.body)["access_token"]
    end

    def get_room_name(token, room_id)
      site = RestClient::Resource.new("https://api.hipchat.com/v2/room/#{room_id}?auth_token=#{token}")
      response = site.post(:content_type=>"application/json")
      return JSON.parse(response.body)["name"]
    end  

  end
end

# == Schema Information
#
# Table name: hipchatconfigs
#
#  id           :integer          not null, primary key
#  room_id      :string
#  token        :string
#  oauth_id     :string
#  oauth_secret :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
