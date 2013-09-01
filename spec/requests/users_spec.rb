require 'spec_helper'

describe 'Users' do
  before :all do
    FactoryGirl.create :role
    FactoryGirl.create_list :exercise, 3
  end

  context 'when does not have language selected' do
    it 'should see language selection dialog', js: true do
      ApplicationController.any_instance.stub(:has_native_language?).and_return(false)
      visit root_path
      find('.modal.language-selector-modal', visible: true)
    end
  end

  context 'when has language selected' do
    it 'should not see language selection dialog', js: true do
      ApplicationController.any_instance.stub(:has_native_language?).and_return(false)
      visit root_path
      page.has_selector?('.modal.language-selector-modal')
      first('.modal.language-selector-modal a.language-flag:first', visible: true).click
      all('.modal.language-selector-modal', visible: true).should be_empty
      visit root_path
      all('.modal.language-selector-modal', visible: true).should be_empty
    end
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
    page.has_selector?('body.user-registrations.edit')
    find('body.user-registrations.edit')
    user = User.find(user.id)
    url = confirm_email_path(email_token: user.email_confirmation.token)
    visit url
    first('input#user_registration_email').value.should eql new_email
  end

  it 'can visit private workspace after sign in' do
    user = sign_in_by_email
    page.has_selector?('body.main-page')
    find('#main-menu .user-profile a').click
    page.has_selector?('body.user-profile')
    find('body.user-profile')
  end

  it 'can not visit private workspace without sign in' do
    visit root_path
    find('#main-menu .user-profile a').click
    page.has_selector?('body.user-sessions')
    find('body.user-sessions')
  end
end

