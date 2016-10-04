class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to user
      #Log the user in and redirect to the user's login page.
    else
      flash.now[:danger] = 'Invalide email/password combination!'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end