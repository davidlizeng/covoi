module SessionsHelper

  def login(user)
    cookies.signed[:id] = {
        :value => user.id,
        :expires => 7.days.from_now
    }
    self.current_user = user
  end

  def logout
    self.current_user = nil
    cookies.delete(:id)
  end

  def require_login
    unless logged_in?
      if request.xhr?
        render js: "window.location='#{root_url}'"
      else
        redirect_to root_url
      end
    end
  end

  def require_logout
    if logged_in?
      redirect_to current_user
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_id(cookies.signed[:id])
  end

end
