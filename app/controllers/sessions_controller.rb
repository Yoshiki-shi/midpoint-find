class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user root_path, notice: 'ログインしました！'
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが正しくありません。'
      render 'new' , status: :unprocessable_entity
    end
  end 
  
  def destry
    session.delete(:user_id)
    redirect_to root_path, status: :see_pther, notice: 'ログアウトしました！'
  end
end
