class PagesController < ApplicationController

  def preview
    @page = Page.new(slide_params[:pages_attributes].values.first)
    render layout: false
  end

end
