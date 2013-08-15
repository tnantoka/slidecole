class UsersController < ApplicationController

  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]
  layout 'blog'

  def show
    @categories = @user.categories.sort

    respond_to do |format|
      format.html
      format.atom 
    end
  end

private
  def set_user
    @user = User.find_by!(username: params[:id])
    @slides = is_own?(@user) ? @user.slides : @user.slides.published
    @slides = @slides.newer.page(params[:p]).per(5)
    set_aside
  end

end
