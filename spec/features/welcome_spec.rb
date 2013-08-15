require 'spec_helper'

describe 'Welcome' do

  describe 'sign_in' do
    context 'invalid' do
      it 'cannot sign in' do
        visit new_user_session_path
        fill_in 'user_password', with: 'password'
        click_button I18n.t(:sign_in)
        expect(page).to have_content(I18n.t(:sign_in))
      end
    end
  end

  describe 'passwords' do
    it 'sends password reset mail' do
      visit new_user_password_path
      fill_in 'user_email', with: 'test@example.com'
      click_button I18n.t(:send_reset)
      expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
    end
  end

  describe 'locale' do

    context 'with valid Accept-Language' do
      it 'uses "en" locale' do
        page.driver.header 'Accept-Language', 'en'
        visit root_path
        I18n.locale = :en
        expect(page).to have_content(I18n.t(:sign_in))
      end
      it 'uses "ja" locale' do
        page.driver.header 'Accept-Language', 'ja'
        visit root_path
        I18n.locale = :ja
        expect(page).to have_content(I18n.t(:sign_in))
      end
    end

    context 'with invalid Accept-Language' do
      it 'uses "en" locale' do
        page.driver.header 'Accept-Language', 'xx'
        visit root_path
        I18n.locale = :en
        expect(page).to have_content(I18n.t(:sign_in))
      end
    end

    context 'users signed in' do
      it "uses user's locale" do
        page.driver.header 'Accept-Language', 'en'
        sign_in
        visit root_path
        I18n.locale = users(:one).lang.code
        expect(page).to have_content(I18n.t(:search))
      end
    end

  end

  describe 'search' do
    it 'returns matched slides' do
      visit root_path
      fill_in 'q', with: 'test'
      click_button I18n.t(:search)
      expect(page).to have_content(I18n.t(:about))
    end    
  end

end
