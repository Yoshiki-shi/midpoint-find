class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 保存に成功した場合の処理（トップページへリダイレクト）
      flash[:success] = "Meet Halfwayへようこそ！"
      redirect_to root_path
    else
      #保存失敗時の新規登録画面を再表示
      render :new , status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
