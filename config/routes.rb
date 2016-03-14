Rails.application.routes.draw do
  root to: 'pages#index'

  get '/hipchat', :controller => 'hipchat', :action => 'index'
  get '/configure', :controller => 'hipchat', :action => 'configure'

  get '/hipchat_configs/remove', :controller => 'hipchat_configs', :action => 'remove'
  post '/hipchat_configs/store', :controller => 'hipchat_configs', :action => 'store'
  get '/hipchat_configs/installed', :controller => 'hipchat_configs', :action => 'installed'
  
  get "/hipchat_configs/send_test_message" => "hipchat_configs#send_test_message"

end
