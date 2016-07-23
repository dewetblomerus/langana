class WorkersController < ApplicationController
  before_action :require_worker_signin, except: [
    :index,
    :new,
    :create,
    :forgot_password,
    :send_reset_code,
    :reset_password,
    :new_password
  ]
  before_action :require_current_worker_or_signed_in_employer, only: [:show]
  before_action :require_correct_worker, only: [:edit, :update, :destroy, :confirm]

  def index
    scope = params[:scope]
    @workers = if scope && Worker.respond_to?(scope)
                 Worker.send(scope)
               else
                 Worker.confirmed
               end
  end

  def show
    @worker = Worker.find(params[:id])
    if current_worker
      if current_worker.confirmed_at.nil?
        # Check that worker should be signed in
        redirect_to(confirm_worker_path(current_worker)) # current_worker?(@worker) || workers_path(@worker)
      end
    end
  end

  def new
    @worker = Worker.new
    @worker.role = 'worker'
    @worker.city = 'Cape Town'
    @worker.country = 'South Africa'
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      session[:worker_id] = @worker.id
      ConfirmationCode.generate(@worker)
      redirect_to confirm_worker_path(@worker), notice: 'Thanks for signing up! Please enter the confirmation code sent to your mobile phone'
    else
      flash[:danger] = 'Sorry, Your account could not be created'
      render :new
    end
  end

  def confirm
  end

  def verify_confirmation
    @worker = Worker.find(params[:id])
    submitted_code = params[:worker][:mobile_confirmation_code]
    @worker.confirmation_attempts += 1
    @worker.save
    if @worker.confirmation_attempts > 9
      redirect_to confirm_worker_path(@worker), alert: 'You have typed in the wrong code too many times, please try again tomorrow'
    elsif BCrypt::Engine.hash_secret(submitted_code, @worker.mobile_code_salt) == @worker.mobile_confirmation_code_digest
      @worker.confirmed_at = Time.now
      @worker.save
      redirect_to @worker, notice: 'Thanks for confirming your mobile number!'
    else
      redirect_to confirm_worker_path(@worker), alert: 'Incorrect confirmation code'
    end
  end

  def send_reset_code
    if @worker = Worker.find_by(mobile_number: ApplicationHelper.format_mobile(params[:mobile_number]))
      if @worker.verification_codes_sent > 9
        redirect_to signin_path, alert: 'Too many attempts for today, please try again tomorrow'
      else
        @worker.verification_codes_sent += 1
        @worker.save
        ConfirmationCode.generate(@worker)
        redirect_to new_password_worker_path(@worker)
      end
    else
      redirect_to forgot_password_path, alert: 'No account with that phone number'
    end
  end

  def new_password
    @worker = Worker.find(params[:id])
  end

  def update
    if @worker.update(worker_params)
      redirect_to @worker, notice: 'Account successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    @worker.destroy
    session[:worker_id] = nil
    redirect_to root_url, alert: 'Account successfully deleted!'
  end

  def reset_password
    @worker = Worker.find(params[:id])
    submitted_code = params[:worker][:mobile_confirmation_code]
    @worker.confirmation_attempts += 1
    @worker.save
    if @worker.confirmation_attempts > 9
      redirect_to forgot_password_path, alert: 'You have typed in the wrong code too many times, please try again tomorrow'
    elsif correct_confirmation_code?(submitted_code)
      @worker.update(worker_params)
      @worker.mobile_confirmation_code_digest = ''
      @worker.save
      session[:worker_id] = @worker.id
      redirect_to @worker, notice: 'Password reset successful!'
    else
      redirect_to new_password_worker_path(@worker), alert: 'Incorrect confirmation code'
    end
  end

  def resend_confirmation
    @worker = Worker.find(params[:id])
    if @worker.confirmed_at
      redirect_to @worker, notice: 'Your number is already confirmed'
    elsif @worker.verification_codes_sent > 9
      redirect_to @worker, alert: 'You have requested too many codes, please try again tomorrow'
    else
      @worker.verification_codes_sent += 1
      @worker.save
      ConfirmationCode.generate(@worker)
      redirect_to confirm_worker_path(@worker), notice: 'We sent it again! Please enter the confirmation code sent to your mobile phone'
    end
  end

  private

  def worker_params
    params.require(:worker).permit(
      :first_name,
      :last_name,
      :mobile_number,
      :email,
      :password,
      :password_confirmation,
      :profile_picture,
      :role,
      :service,
      :home_language,
      :id_or_passport_number,
      :country_of_citizenship,
      :first_language,
      :second_language,
      :third_language,
      :work_permit_status
    )
  end

  def require_correct_worker
    @worker = Worker.find(params[:id])
    redirect_to root_url unless current_worker?(@worker)
  end

  def correct_worker?
    @worker = Worker.find(params[:id])
    current_worker?(@worker)
  end

  def require_confirmed_employer
    redirect_to new_employer_session_path unless employer_signed_in?
  end

  def require_current_worker_or_signed_in_employer
    if correct_worker? || employer_signed_in?
      # do nothing
    else
      redirect_to new_employer_session_path
    end
  end

  def correct_confirmation_code?(submitted_code)
    BCrypt::Engine.hash_secret(submitted_code, @worker.mobile_code_salt) == @worker.mobile_confirmation_code_digest
  end

end
