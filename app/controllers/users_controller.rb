class UsersController < ApplicationController

  before_action :set_user, except: [:index]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if params[:user] && @user.update(user_params)
      flash[:notice] = "更新しました"
      redirect_to(users_path(skip_api: "true"))
    end
    if params[:hide] && @user.update(hide: params[:hide])
      redirect_to(users_path(skip_api: "true"))
      flash[:notice] = "削除しました。"
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:salary)
    end

    def set_user
      @user = User.find_by(user_id: params[:id])
    end
  
end
