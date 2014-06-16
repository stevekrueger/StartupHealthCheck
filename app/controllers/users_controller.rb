class UsersController < ApplicationController
  before_filter :check_session, only: [:edit, :update, :toggle_email_digest_subscription]
  def index
    @users = User.all.page
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue
      ActiveRecord::RecordNotFound
      flash[:error] = "That user does not exist"
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    @user = current_user
    if @user.email.nil? && params[:user][:email].present?
      SendVerificationEmail.call(params[:user][:email], @user, session[:current_connection])
      @user.update(user_params)
      redirect_to user_path(@user)
    else  
      @user.update(user_params)
      redirect_to edit_user_path(@user)
    end
  end

  def toggle_email_digest_subscription
    if current_user.email_digest?
      current_user.update(email_digest: false)
    else
      current_user.update(email_digest: true)
    end
    redirect_to edit_user_path(current_user)
  end

  private

  def check_session
    redirect_to unset_session_path if session[:expires_at] < Time.current
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
