module SessionsHelper

  def login(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # returns the current user if logged in
  def current_user
    if (user_id = session[:user_id)]
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end

  # return true if user logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end
end
