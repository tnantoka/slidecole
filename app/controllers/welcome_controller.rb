class WelcomeController < ApplicationController

  skip_before_action :authenticate_user! 

  def index
    @about = User.slidecole.slides.find_by(slug: 'about_ja') if I18n.locale == :ja
    @about ||= User.slidecole.about
    @popular_slides = Slide.published.popular.limit(6)
    @newer_slides = Slide.published.newer.limit(6)
    @popular_users = User.popular.limit(3)
    @newer_users = User.newer.limit(3)
  end

  def search
    @slides = Slide.search(query: params[:q], username: params[:u]).newer.published.page(params[:p]).per(20)
  end
end
