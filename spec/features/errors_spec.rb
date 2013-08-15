require 'spec_helper'

describe 'Errors' do

  describe 'error_500' do
    it "raise 500" do
      visit '/errors/error_500'
      expect(page).to have_content('500')
    end
  end

end
 
