class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def letsencrypt
    # use your code here, not mine
    render plain: "YSpr1DJREUKPyPhxn7rnKeEOSIDoyIixbBeLjdANoIw.zjNheANE3yqJ5fUgoM9zvHL1aBMCZK7EpW7YfjbFDC0"
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
