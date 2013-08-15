class Lang < ActiveRecord::Base

  def name
    I18n.t("lang.#{code}")
  end
end
