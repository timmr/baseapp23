class UserSessionsController < ApplicationController
  layout 'login'

  skip_before_filter :authorize_user, :only => [:new, :create, :destroy]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(:login => params[:login], :password => params[:password])
    if @user_session.save
      redirect_back_or_default(root_url)
    else
      render :action => :new
      logger.warn "LOGIN FAILED: for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
    end
  end

  def destroy
    current_user_session.destroy unless current_user_session.nil?
    redirect_to new_user_session_url
  end

end

