Rails.application.routes.draw do

  #delete '/logout', to: 'sessions#destroy'
  #get '/auth/:provider/callback', to: 'sessions#create'
  #get '/auth/failure', to: 'sessions#auth_failure'

  root to: 'pages#index'

  get '/hipchat', :controller => 'hipchat', :action => 'index'

  get '/sessions/remove', :controller => 'sessions', :action => 'remove'
  post '/sessions/store', :controller => 'sessions', :action => 'store'

end
