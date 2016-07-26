class WorkersSessionsController < ApplicationController
  def new
  end

  def create
    if worker = Worker.authenticate(params[:mobile_number], params[:password])
      session[:worker_id] = worker.id
      flash[:notice] = "Welcome back, #{worker.first_name}!"
      redirect_to(url_after_signin(worker))
      session[:intended_url] = nil
    else
      flash.now[:alert] = 'Invalid email/password combination!'
      redirect_to(signin_path)
    end
  end

  def destroy
    session[:worker_id] = nil
    redirect_to root_url, notice: 'You are signed out'
  end

  private

  def url_after_signin(worker)
    if worker.confirmed_at
      session[:intended_url] || worker
    else
      confirm_worker_path(worker)
    end
  end
end
