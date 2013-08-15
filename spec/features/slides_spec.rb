require 'spec_helper'

describe 'Slides', :js do
  
  context 'registered' do
    before do
      page.driver.headers = { 'Accept-Language' => 'en' }
      sign_in
    end

    describe 'show' do
      it 'returns slide' do
        visit user_slide_path('slidecole', 'about')
        expect(page).to have_content(I18n.t(:about))
      end
    end

    describe 'plain' do
      it 'returns plain slide' do
        visit plain_user_slide_path('slidecole', 'about')
        expect(page).to have_content('slidecole')
      end
    end

    describe 'play' do
      it 'plays slide' do
        visit play_user_slide_path('slidecole', 'about')
        expect(page).to have_content('slidecole')
      end
    end

    describe 'new' do
      it 'returns slide form' do
        visit new_slide_path
        expect(page).to have_content("#{I18n.t('activerecord.models.page')} 1")
        expect(page).to have_content(I18n.t('enumerize.page.kind.cover'))
      end
    end

    describe 'create' do
      context 'valid' do
        it 'creates slide' do
          visit new_slide_path
          fill_in 'slide[title]', with: 'Test slide'
          fill_in 'slide[pages_attributes][0][title]', with: 'Test page'
          page.execute_script("$('.js_slide_form').submit()")
          expect(page).to have_content('Test slide')
          expect(Page.last.title).to eq('Test page')
        end
      end
      context 'invalid' do
        it "does't create slide" do
          visit new_slide_path
          fill_in 'slide[title]', with: 'Test slide'
          fill_in 'slide[pages_attributes][0][title]', with: 'Test page'
          page.execute_script("$('.js_options_btn').click()")
          fill_in 'slide[slug]', with: 'about'
          page.execute_script("$('.js_slide_form').submit()")
          expect(page).to have_content(I18n.t('errors.messages.taken'))
        end
      end
    end

    describe 'edit' do
      before do
        visit new_slide_path
        page.execute_script("$('.js_options_btn').click()")
        fill_in 'slide[title]', with: I18n.t(:untitled)
        fill_in 'slide[slug]', with: 'test'
        page.execute_script("$('.js_slide_form').submit()")
        expect(page).to have_content(I18n.t(:untitled))
      end
      context 'valid' do
        it 'edits slide' do
          visit edit_user_slide_path('test', 'test')
          fill_in 'slide[title]', with: 'Test slide'
          fill_in 'slide[pages_attributes][0][title]', with: 'Test page'
          page.execute_script("$('.js_slide_form').submit()")
          expect(page).to have_content('Test slide')
          expect(Page.last.title).to eq('Test page')
        end
      end
      context 'invalid' do
        it "does't edit slide" do
          visit edit_user_slide_path('test', 'test')
          fill_in 'slide[title]', with: 'Test slide'
          fill_in 'slide[pages_attributes][0][title]', with: 'Test page'
          page.execute_script("$('.js_options_btn').click()")
          fill_in 'slide[slug]', with: 'about'
          page.execute_script("$('.js_slide_form').submit()")
          expect(page).to have_content(I18n.t('errors.messages.taken'))
        end
      end
    end

    describe 'preview' do
      it 'shows preview' do
        visit new_slide_path
        fill_in 'slide[title]', with: 'Test slide'
        fill_in 'slide[pages_attributes][0][title]', with: 'Test page'
        page.execute_script("$('.js_preview_btn').click()")
        # doesn't raise js error
      end
    end

    describe 'comment' do
      it 'creates comment' do
        visit user_slide_path('slidecole', 'about')
        fill_in 'comment[comment]', with: 'Test comment'
        click_button('Create')
        expect(page).to have_content('Test comment')
      end
    end

    describe 'destroy' do
      before do
        visit new_slide_path
        page.execute_script("$('.js_options_btn').click()")
        fill_in 'slide[title]', with: I18n.t(:untitled)
        fill_in 'slide[slug]', with: 'test'
        page.execute_script("$('.js_slide_form').submit()")
        expect(page).to have_content(I18n.t(:untitled))
      end
      it 'deletes slide' do
        visit edit_user_slide_path('test', 'test')
        within '.js_slide_form' do
          first(:link, I18n.t(:delete)).click()
        end
        expect(page).to have_content(I18n.t('flash.models.destroy', model: Slide.model_name.human))
      end
    end

    describe 'not_found' do
      it 'raises error ' do
        visit edit_user_slide_path('slidecole', 'about')
        expect(page).to have_content('404')
      end
    end
  end

end
