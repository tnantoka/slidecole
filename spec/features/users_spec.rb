require 'spec_helper'

describe 'Users' do
  
  context 'registered' do
    before do
      page.driver.header 'Accept-Language', 'en'
      sign_in
    end

    describe 'edit' do
      context 'valid' do
        it 'edits user' do
          visit edit_user_registration_path
          fill_in 'user_username', with: 'edited'
          fill_in 'user_current_password', with: 'password'
          click_button 'Update'
          expect(User.exists?(username: 'edited')).to be
        end
      end
      context 'invalid' do
        it 'edits user' do
          visit edit_user_registration_path
          fill_in 'user_username', with: 'edited'
          fill_in 'user_current_password', with: ''
          click_button 'Update'
          expect(User.exists?(username: 'edited')).to be_false
        end
      end
    end

    describe 'search' do
      it 'returns matched slides' do
        visit user_path('test')
        within '.blog' do
          fill_in 'q', with: 'about'
          click_button I18n.t(:search)
        end
        expect(page).to have_content(I18n.t(:about))
        expect(page).to_not have_content('tnantoka')
      end    
    end
  end
end
