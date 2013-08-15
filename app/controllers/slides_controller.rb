class SlidesController < ApplicationController

  before_action :set_slide, only: [:show, :edit, :update, :destroy, :play, :download, :plain, :create_comment]
  skip_before_action :authenticate_user!, only: [:show, :play, :plain]
  
  def index
    @slides = current_user.slides.newer
  end

  def show
    impressionist(@slide) unless can_edit?(@slide)
    @comment = Comment.new
    @comments = @slide.comments
    set_aside
    render layout: 'blog'
  end

  def new
    @slide = current_user.slides.build
    @slide.pages.build(user: current_user)
    assign_gon
  end

  def create
    @slide = Slide.new(slide_params)
    @slide.user = current_user

    if @slide.save
      redirect_to [current_user, @slide], notice: I18n.t('flash.models.create', model: Slide.model_name.human) 
    else
      assign_gon
      render action: :new
    end
  end

  def edit
    not_found unless can_edit?(@slide)
    assign_gon
  end

  def update
    not_found unless can_edit?(@slide)
    if @slide.update(slide_params)
      redirect_to [current_user, @slide], notice: I18n.t('flash.models.update', model: Slide.model_name.human) 
    else
      assign_gon
      render action: :edit
    end
  end

  def play
    @pages = @slide.pages.sort
    render layout: false
  end

  def blank
    @slide = Slide.new
    @pages = []
    render :play, layout: false
  end

  def download
  end

  def plain
    @pages = @slide.pages
    render layout: false
  end

  def destroy
    not_found unless can_edit?(@slide)
    not_found unless @slide.can_delete?
    @slide.destroy
    redirect_to :slides, notice: I18n.t('flash.models.destroy', model: Slide.model_name.human) 
  end

  def preview
    @slide = Slide.new(slide_params)
    @slide.user = current_user
    @pages = @slide.pages
    render :play, layout: false
  end

  # Comment
  def create_comment
    comment = @slide.comments.build(comment_params)
    comment.user = current_user
    comment.save!
    render comment, layout: false
  end

private
  def set_slide
    @user = User.find_by!(username: params[:user_id])
    @slide = @user.slides.find_by(slug: params[:id])
    @slide = @user.slides.find(params[:id]) if @slide.nil?

    not_found if @slide.is_draft? && !can_edit?(@slide)
  end

  def assign_gon
    gon.pages = @slide.new_record? ? @slide.pages : @slide.pages.sort
    gon.kinds = Page.kind.values
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

end

