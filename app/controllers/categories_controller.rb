class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show, :uncategorized]

  def show
    @slides = @slides.newer.page(params[:p]).per(5)
    render layout: 'blog'
  end

  def uncategorized
    set_user
    @slides = is_own?(@user) ? @user.slides.uncategorized : @user.slides.uncategorized.published
    @slides = @slides.newer.page(params[:p]).per(5)
    render :show, layout: 'blog'
  end

  def index
    @categories = current_user.categories
    @category ||= Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user

    if @category.save
      redirect_to :categories, notice: I18n.t('flash.models.create', model: Category.model_name.human) 
    else
      index
      render action: :index
    end
  end

  def destroy
    not_found unless can_edit?(@category)
    @category.destroy
    redirect_to :categories, notice: I18n.t('flash.models.destroy', model: Category.model_name.human) 
  end

  def edit
    not_found unless can_edit?(@category)
  end

  def update
    not_found unless can_edit?(@category)
    before_slug = @category.slug
    if @category.update(category_params)
      redirect_to :categories, notice: I18n.t('flash.models.update', model: Category.model_name.human) 
    else
      @category.slug = before_slug
      render action: :edit
    end
  end


private
  def set_user
    @user = params[:user_id].present? ? User.find_by!(username: params[:user_id]) : current_user
    set_aside
  end

  def set_category
    set_user
    @category = @user.categories.find_by(slug: params[:id])
    @category = @user.categories.find(params[:id]) if @category.nil?
    @slides = is_own?(@user) ? @category.slides : @category.slides.published
    @slide = @slides.first
  end

  def category_params
    params.require(:category).permit(:name, :slug)
  end

end
