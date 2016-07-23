class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def require_worker_signin
    unless current_worker
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: 'Please sign in first'
    end
  end

  def current_user
    assign_user if @current_user.nil?
    @current_user
  end
  helper_method :current_user

  def assign_user
    @current_user = current_employer
  end

  def current_worker
    @current_worker ||= Worker.find(session[:worker_id]) if session[:worker_id]
  end
  helper_method :current_worker

  def current_worker?(worker)
    current_worker == worker
  end
  helper_method :current_worker?
end
