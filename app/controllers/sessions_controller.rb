class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated. Check your email for an activation link"
        flash[:warning] = message
        redirect_to root_url
      end
      #Log the user in and redirect to the user's login page.
    else
      flash.now[:danger] = 'Invalid email/password combination!'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
