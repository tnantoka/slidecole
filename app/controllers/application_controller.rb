class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  unless Rails.env.development?
    rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    #rescue_from ActionController::UnknownAction, with: :error_404
    rescue_from ::AbstractController::ActionNotFound, with: :error_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_404(exception = nil)
    render_error(404, exception)
  end

  def render_500(exception = nil)
    render_error(500, exception)
  end

  def render_error(status, exception = nil)
    if exception
      logger.info "Rendering #{status} with exception: #{exception.message}"
    end

    render template: "errors/error_#{status}", status: status, layout: 'errors', content_type: 'text/html'
  end

  def set_locale
    locale = user_signed_in? ? current_user.lang.code : extract_locale_from_accept_language_header
    I18n.locale = Lang.exists?(code: locale) ? locale : I18n.default_locale
  end

  def can_edit?(target)
    target.user == current_user
  end
  helper_method :can_edit?

  def is_own?(user)
    user == current_user
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def set_aside
    @recent_comments = Comment.recent(@user).limit(5)

    @categories = @user.categories
    @newer_slides = @user.slides.published.newer.limit(5)
    @popular_slides = @user.slides.published.popular.limit(5)
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :lang_id) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :lang_id, :current_password) }
  end

  def slide_params
    params.require(:slide).permit(:title, :slug, :lang_id, :category_id, :is_draft, pages_attributes: [:id, :title, :kind, :order, :_destroy, content: [
      :copyright,
      :url,
      :body,
      :source,
      :comment,
      :text,
      :cite,
      :rows,
      :cols,
      items: [],
      records: [items: []],
    ]])
  end

private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
  end

end
