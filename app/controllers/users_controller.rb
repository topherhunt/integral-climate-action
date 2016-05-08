class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(published: true).order("published_at DESC").limit(10)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Your profile has been updated."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :image, :skill_list, :passion_list, :trait_list, :dream_of_future_where)
  end

end
