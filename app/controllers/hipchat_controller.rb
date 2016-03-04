class HipchatController < ApplicationController
	def index
		return capabilities_descriptor			
	end

	private
		def capabilities_descriptor
			capabilities = { 
        "apiVersion" => "1:1",
				"name" => "Onazar Hipchat Add-On",
				"description"=> "Onazar Hipchat integration",
				"key"=> "onazar.hipchat.addon",
				"vendor" => {
			    						"url" => "http://ec2-54-164-6-135.compute-1.amazonaws.com",
			    						"name" => "onazar"
			    					},
				"links" => {
			    						"homepage" => "http://ec2-54-164-6-135.compute-1.amazonaws.com",
			    						"self" => "http://ec2-54-164-6-135.compute-1.amazonaws.com"
		  							},
			  "capabilities" => {
			  	"oauth2Provider" => { 
			  		"tokenUrl" => "https://api.hipchat.com/v2/oauth/token"
			  	} , 
			    "hipchatApiConsumer" => {
			      "scopes" => [
			        "send_notification", 
              "view_room"
			      ],
			      "fromName" => "onazar"
			    },
			    "installable" => {
			    	"installedUrl" => "#{ENV['DOMAIN']}/hipchat_configs/installed",
			    	"uninstalledUrl" => "#{ENV['DOMAIN']}/hipchat_configs/remove",
			    	"allowRoom" => true,
			    	"allowGlobal" => false,
			    	"callbackUrl" => "#{ENV['DOMAIN']}/hipchat_configs/store"
			    },
			  }
			}
      Rails.logger.info("-------------capabilities.to_json-----> #{capabilities.to_json}")
			render :json => capabilities.to_json
		end
end
