require 'spec_helper'

describe 'Attachments' do

  context 'registered' do

    before do
      page.driver.header 'Accept-Language', 'en'
      sign_in
      @attachment = Attachment.create(user_id: 3, file: File.new("#{Rails.root}/app/assets/images/logo.png"))
    end

    describe 'index' do
      it 'returns attachments' do
        visit attachments_path
        expect(page).to have_content('logo.png')
      end
      it 'returns attachments json' do
        visit attachments_path(format: :json)
        expect(page).to have_content('logo.png')
      end
    end

    describe 'show' do
      it 'returns attachment' do
        expect {
          visit attachment_path(@attachment)
        }.to_not raise_error
      end
    end

    describe 'create' do
      it 'creates attachment' do
        visit attachments_path
        attach_file('attachment_file', "#{Rails.root}/app/assets/images/blank.png")
        click_button('Create')
        visit attachments_path
        expect(page).to have_content('blank.png')
      end
    end

    describe 'destroy' do
      it 'deletes attachment' do
        visit attachments_path
        first(:link, I18n.t(:delete)).click()
        expect(page).to have_content(I18n.t('flash.models.destroy', model: Attachment.model_name.human))
      end
    end

 
  end

end
 
