class MembersController < ApplicationController
  before_action :require_login
  before_action :set_member, only: %i[edit update destroy]

  def index
    @members = current_user.members.order(created_at: :asc)
    @member = current_user.members.build
  end

  def create
    @member = current_user.members.build(member_params)
    if @member.save
      redirect_to members_path, notice: "#{@member.name}（#{@member.station_name}駅）を登録しました"
    else
      @members = current_user.members.order(created_at: :asc)
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
    @member.destroy!
    redirect_to members_path, notice: "メンバーを削除しました", status: :see_other
  end

  private

  def set_member
    @member = current_user.members.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:name, :station_name, :lat, :lng)
  end
end