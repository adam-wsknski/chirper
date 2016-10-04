module SessionsHelper

  def login(user)
    session[:user_id] = user.id
  end

  # logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # returns the current user if logged in
  def current_user
      @current_user ||= User.find_by(id: session[:user_id])
  end

  # return true if user logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end
end
