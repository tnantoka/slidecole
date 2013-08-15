require 'spec_helper'

describe ErrorsController do

  describe "GET 'error_500'" do
    it "render 500 page" do
      get :error_500
      response.status.should == 500
      response.should render_template("errors/error_500")
    end
  end

end
