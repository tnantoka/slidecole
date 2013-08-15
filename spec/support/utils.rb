def sign_in(user: users(:one))
  visit new_user_session_path
  fill_in 'user_login', with: user.username
  fill_in 'user_password', with: 'password'
  click_button I18n.t(:sign_in)
end
