class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = t('controllers.profile.update')
      redirect_to profile_path(@user)
    else
      render :show
    end
  end

  def update_password
    @user = current_user
    if @user.update_with_password(user_password_params)
      flash[:success] = t('controllers.profile.update_password')
      redirect_to profile_path(@user)
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def user_password_params
    params.require(:user).permit(:current_password,
                                 :password,
                                 :password_confirmation)
  end
end
