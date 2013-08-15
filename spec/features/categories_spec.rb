require 'spec_helper'

describe 'Categories' do

  context 'registered' do
    before do
      page.driver.header 'Accept-Language', 'en'
      sign_in
    end

    describe 'uncategorized' do
      it 'returns uncategorized slides' do
        visit uncategorized_user_categories_path('test')
        expect(page).to have_content(I18n.t(:about))
      end
    end

    describe 'index' do
      it 'returns categories' do
        visit categories_path
        expect(page).to have_content(I18n.t(:uncategorized))
      end
    end

    describe 'index' do
      it 'returns categories' do
        visit categories_path
        expect(page).to have_content(I18n.t(:uncategorized))
      end
    end

    describe 'create' do
      context 'valid' do
        it 'creates category' do
          visit categories_path
          fill_in 'category[name]', with: 'Test category'
          fill_in 'category[slug]', with: 'test'
          click_button('Create')
          click_link('Test category')
          expect(page).to have_content('Test category')
        end
      end
      context 'invalid' do
        it "does't create category" do
          visit categories_path
          fill_in 'category[name]', with: 'Test category'
          fill_in 'category[slug]', with: 'uncategorized'
          click_button('Create')
          expect(page).to have_content(I18n.t('errors.messages.taken'))
        end
      end
    end

    describe 'destroy' do
      before do
        visit categories_path
        fill_in 'category[name]', with: 'Test category'
        fill_in 'category[slug]', with: 'test'
        click_button('Create')
        expect(page).to have_content('Test category')
      end
      it 'deletes category' do
        first(:link, I18n.t(:delete)).click()
        expect(page).to have_content(I18n.t('flash.models.destroy', model: Category.model_name.human))
      end
    end

    describe 'edit' do
      before do
        visit categories_path
        fill_in 'category[name]', with: 'Test category'
        fill_in 'category[slug]', with: 'test'
        click_button('Create')
        expect(page).to have_content('Test category')
      end
      context 'valid' do
        it 'edits category' do
          visit edit_category_path('test', 'test')
          fill_in 'category[name]', with: 'Edited category'
          fill_in 'category[slug]', with: 'test'
          click_button('Update')
          expect(page).to have_content('Edited category')
        end
      end
      context 'invalid' do
        it "does't edit category" do
          visit edit_category_path('test', 'test')
          fill_in 'category[name]', with: 'Edited category'
          fill_in 'category[slug]', with: 'uncategorized'
          click_button('Update')
          expect(page).to have_content(I18n.t('errors.messages.taken'))
        end
      end
    end


  end


end
 
