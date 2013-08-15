class Category < ActiveRecord::Base
  has_many :slides, dependent: :nullify
  belongs_to :user

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :user_id } , format: { with: /\A[a-zA-Z0-9_\-]+\z/ }, allow_blank: true

  validates_each :slug do |record, attr, value|
    record.errors.add(attr, :taken) if value == 'uncategorized'
  end

  scope :sort, -> {}

  def to_param
    slug.presence || id.to_s
  end
end
