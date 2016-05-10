class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :collect_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      #保存に成功した場合はプロフィールページへリダイレクト
      redirect_to user_path(@user) , notice: 'プロフィールを編集しました'
    else
      #保存に失敗した場合は編集画面に戻す
      render 'edit'
    end
  end
  
  def followings
    # 自分がフォローしているユーザー
    @title = "Followings"
    @user = User.find(params[:id])
    @users = @user.following_users
    render 'show_follow'
  end
  
  def followers
    # 自分をフォローしているユーザー
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.follower_users
    render 'show_follow'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def collect_user
    redirect_to root_path if @user != current_user
  end
end
