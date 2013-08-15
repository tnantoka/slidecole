class Slide < ActiveRecord::Base
  belongs_to :category
  belongs_to :lang
  belongs_to :user, counter_cache: true
  has_many :pages, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { scope: :user_id } , format: { with: /\A[a-zA-Z0-9_\-]+\z/ }, allow_blank: true

  accepts_nested_attributes_for :pages, allow_destroy: true

  scope :published, -> { where(is_draft: false) }
  scope :uncategorized, -> { where(category_id: nil) }
  scope :popular, -> { order('impressions_count DESC') }
  scope :newer, -> { order('created_at DESC') }

  is_impressionable counter_cache: true
  acts_as_commentable

  default_value_for :title do 
    I18n.t(:untitled)
  end
  default_value_for :lang_id do 
    Lang.find_by(code: I18n.locale).id 
  end

  def to_param
    slug.presence || id.to_s
  end

  def is_about?
    user.slides.first == self
  end

  def can_delete?
    !new_record? && !is_about?
  end

  def summary
    text = []
    pages.each do |page|
      text << page.title
      pages.each do |k, v|
        text << v
      end
    end
    text.join(' ')    
  end

  def self.search(query: query, username: nil)
    query = query.to_s.strip
    return none if query.blank?

    queries = split_query(query)
    conds = build_conds(queries)

    slides = username.nil? ? Slide : Slide.where(user_id: User.find_by!(username: username))
    return slides.where(conds).joins(:pages).uniq
  end

  def self.split_query(query)
    return [] if query.blank?
    query.split(/[\s　]+/)
  end

  def self.build_conds(queries)
    slide_table = Slide.arel_table
    page_table = Page.arel_table

    conds = nil
    queries.each do |q|
      pattern = "%#{q}%"
      likes = [
        slide_table[:title].matches(pattern),
        slide_table[:slug].matches(pattern),
        page_table[:title].matches(pattern),
        page_table[:content].matches(pattern)
      ] 
      likes.each do |like|
        conds = conds.present? ? conds.or(like) : like
      end
    end
    return conds
  end

end
