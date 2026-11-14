class ProfilesController < ApplicationController
  #ログインしている人だけがアクセスできるようにする
  before_action :authenticate_user! 

  #マイページを表示するアクション
  def show
    @user = current_user # ログイン中のユーザー情報を取得して変数@userに入れる
  end

  #プロフィール編集画面を表示するアクション
  def edit
    @user = current_user # 編集フォームで使うためにログイン中のユーザー情報を取得する
  end

  #フォームから送信されたデータを保存（更新）するアクション
  def update
    @user = current_user
    
    # ユーザーのデータを、後述の strong parameters (profile_params) の内容で更新を試みる
    if @user.update(profile_params)
      # 更新に成功した場合：マイページ画面にリダイレクトし、成功メッセージを表示
      redirect_to profile_path, notice: 'プロフィールを更新しました！'
    else
      # 更新に失敗した場合（バリデーションエラーなど）：編集画面をもう一度表示（status: :unprocessable_entity はRails 7の標準作法）
      render :edit, status: :unprocessable_entity
    end
  end

  private

  #セキュリティ対策：フォームから受け取ってよい安全なデータを限定する (Strong Parameters)
  def profile_params
    params.require(:user).permit(:name, :nearest_station_name)
  end
end