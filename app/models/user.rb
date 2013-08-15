class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :username, presence: true, uniqueness: true#, format: { with: /\A[a-zA-Z0-9_\-]+\z/ }

  validates_each :username do |record, attr, value|
    routes = Rails.application.routes.routes.map { |r| r.name }.reject { |r| r.nil? } 
    if !(value =~ /\A[a-zA-Z0-9_\-]+\z/) || routes.include?(value)
      record.errors.add(attr, :invalid) 
    end
  end

  attr_accessor :login

  belongs_to :lang
  has_many :slides, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :attachments, dependent: :destroy

  after_create :add_about

  scope :popular, -> { order('slides_count DESC') }
  scope :newer, -> { order('created_at DESC') }

  default_value_for :lang_id do 
    lang = Lang.find_by(code: I18n.locale.to_s)
    lang.present? ? lang.id : Lang.first.id
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def avatar(size: 24)
    hash = Digest::MD5.hexdigest(self.email.downcase)
    return "//gravatar.com/avatar/#{hash}.png?s=#{size}&d=mm"
  end

  def about
    slides.first
  end

  def to_param
    username
  end

  def self.slidecole
    User.find_by(username: 'slidecole')
  end

private
  def add_about
    ActiveRecord::Base::transaction do
      about = slides.build 
      with_locale(lang.code) do
        about.title = I18n.t(:about) 
      end
      about.slug = 'about'
      page = about.pages.build
      page.title = username
      page.kind = :user
      page.content = {
        url: avatar(size: 128)
      }
      about.save!
      page.save!
    end
  end

private
  def with_locale(locale, &block)
    original_locale = I18n.locale
    I18n.locale = locale
    result = yield
    I18n.locale = original_locale
    return result
  end
 
end
