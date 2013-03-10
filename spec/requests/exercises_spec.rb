require 'spec_helper'

describe 'Exercises' do
  #it 'does not allow view and change private exercises' do
    #user = sign_in_by_email
    #private_exercise = Exercise.where('user_id IS NULL').first
    #visit users_exercise_path(private_exercise)
    #page.has_selector?('body.main_page')
    #find('body.main_page')
    #find('#flash_alert').text.should eq I18n.t('flash.users/exercises.access_denied')

    #visit edit_users_exercise_path(private_exercise)
    #page.has_selector?('body.main_page')
    #find('body.main_page')
    #find('#flash_alert').text.should eq I18n.t('flash.users/exercises.access_denied')
  #end

  #it 'allows view and change own exercises' do
    #user = sign_in_by_email
    #own_exercise = Exercise.where('user_id IS NOT NULL').first
    #visit users_exercise_path(private_exercise)
    #page.has_selector?('body.main_page')
    #find('body.main_page')
    #find('#flash_alert').text.should eq I18n.t('flash.users/exercises.access_denied')

    #visit edit_users_exercise_path(private_exercise)
    #page.has_selector?('body.main_page')
    #find('body.main_page')
    #find('#flash_alert').text.should eq I18n.t('flash.users/exercises.access_denied')
  #end
end

