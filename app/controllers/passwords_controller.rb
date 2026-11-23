class PasswordsController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    unless @user.authenticate(params.dig(:user, :current_password).to_s)
      @user.errors.add(:current_password, "が正しくありません")
      return render :edit, status: :unprocessable_content
    end

    if params.dig(:user, :password).blank?
      @user.errors.add(:password, "を入力してください")
      return render :edit, status: :unprocessable_content
    end

    if @user.update(password_params)
      redirect_to profile_path, notice: "パスワードを変更しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
