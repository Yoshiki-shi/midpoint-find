class SessionsController < ApplicationController
  def new
  end

  def create
    email = (params[:email] || params.dig(:session, :email)).to_s.downcase.strip
    password = params[:password] || params.dig(:session, :password)

    user = User.find_by(email: email)
    if user&.authenticate(password)
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "ログアウトしました", status: :see_other
  end
end