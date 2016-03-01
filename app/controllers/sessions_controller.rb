class SessionsController < ApplicationController

  def new
    redirect_to root_path
  end

  def store
    Rails.logger.info("-------params----> #{params}")
    @user = User.from_omniauth(:oauth_id => params[:oauthId], :oauth_secret => params[:oauthSecret])
    session[:user_id] = @user.id
    flash[:success] = '!!!STORED!!!'
    redirect_to root_path
  end

  def remove
    if current_user
      session.delete(:user_id)
      flash[:success] = 'See you!'
    end
    redirect_to root_path
  end

  #def auth_failure
  #  redirect_to root_path
  #end
end
