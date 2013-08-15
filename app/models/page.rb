class Page < ActiveRecord::Base
  extend Enumerize

  belongs_to :slide
  serialize :content

  attr_accessor :user

  scope :sort, -> { order('pages.order') } 

  enumerize :kind, in: [:cover, :text, :list, :code, :quote, :table, :image, :user, :free], default: :cover

  default_value_for :title do 
    I18n.t(:untitled)
  end
  default_value_for :content do |page|
    {
      copyright: page.user.try(:username)
    }
  end
  default_value_for :order do |page|
    page.slide.try(:pages).try(:size).to_i
  end


end
