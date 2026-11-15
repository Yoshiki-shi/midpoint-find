class MembersController < ApplicationController
  before_action :require_login
  before_action :set_member, only: %i[edit update destroy]

  def index
    @members = current_user.members
    @new_member = current_user.members.new
  end

  def create
    @new_member = current_user.members.new(member_params)
    if @new_member.save  # @member から @new_member に修正！
      redirect_to members_path, notice: "メンバーを登録しました"
    else
      @members = current_user.members
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to members_path, notice: "メンバー情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member.destroy
    redirect_to members_path, notice: "メンバーを削除しました"
  end

  private

  def set_member
    @member = current_user.members.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :station_name, :lat, :lng)
  end
end