require 'rest_client'

class User < ActiveRecord::Base
  class << self
    def from_omniauth(oauth_id, secret_key)
      user = find_or_create_by(uid: oauth_id, provider: 'hipchat')
      user.name = get_access_token(oauth_id,secret_key)
      user.location = 'location'
      user.image_url = 'image'
      user.url = 'urls'
      user.save!
      user
    end

    private

    def get_access_token(oauth_id,secret_key)
      params = URI::encode("grant_type=client_credentials&scope=send_notification")
      site = RestClient::Resource.new("https://api.hipchat.com/v2/oauth/token?#{params}",oauth_id,secret_key)
      response = site.post(:content_type=>"application/json")
      @data.update_attributes(:access_token => JSON.parse(response.body)["access_token"])
      return JSON.parse(response.body)
    end

    def post_hipchat(token,message,room_id)
      begin
        json_data = {"color" => "green", "message" => message, "notify" => true, "message_format" => "html"}
        site=RestClient::Resource.new("https://api.hipchat.com/v2/room/#{room_id}/notification?auth_token=#{token}")
        response=site.post(json_data.to_json, :content_type=>"application/json")
        render :json => {"message" => "success"}
      rescue Exception => e
        regenerated_token = get_access_token(@data.attributes[:oauth_id],@data.attributes[:secret_key])
        post_hipchat(regenerated_token["access_token"],message,room_id)
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  provider   :string
#  uid        :string
#  name       :string
#  location   :string
#  image_url  :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
