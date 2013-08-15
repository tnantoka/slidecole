class ErrorsController < ApplicationController
  skip_before_action :authenticate_user! 

  def error_500
    raise '500'
  end

  #def error_404
  #  raise ActiveRecord::RecordNotFound
  #end
end
