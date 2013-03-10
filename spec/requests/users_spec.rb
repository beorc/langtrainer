require 'spec_helper'

describe 'Users' do
  before :all do
    FactoryGirl.create :role
    FactoryGirl.create_list :exercise, 3
  end

  it 'can enter by email' do
    user = sign_in_by_email
    page.should have_content user.email
  end

  it 'can change email' do
    user = sign_in_by_email
    visit edit_user_registration_path
    new_email = 'bairkan@gmail.com'
    fill_in('user_registration[email]', with: new_email)

    click_on 'update_registration'
    url = confirm_email_path(email_token: user.email_confirmation.token)
    visit url
    first('input#user_registration_email').value.should eql new_email
  end

  it 'can visit private workspace after sign in' do
    user = sign_in_by_email
    find('.user-profile a').click
    page.has_selector?('body.user-profile')
    find('body.user-profile')
  end

  it 'can not visit private workspace without sign in' do
    visit root_path
    find('.user-profile a').click
    page.has_selector?('body.user_sessions')
    find('body.user_sessions')
  end
end

