require 'spec_helper'

describe Users::SentencesController do
  render_views

  before :all do
    FactoryGirl.create :role

    @user = FactoryGirl.create :user
    @another_user = FactoryGirl.create :user
    @public_exercise = FactoryGirl.create :exercise
    @own_exercise = FactoryGirl.create :exercise, owner: @user
    @alien_exercise = FactoryGirl.create :exercise, owner: @another_user
  end

  describe 'for member' do

    it 'does not allow to create new with maximum sentences created' do
      FactoryGirl.create_list :sentence, User::SENTENCES_MAX, owner: @user, exercise: @public_exercise
      login_user(@user)
      get :new
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/sentences.access_denied')
    end
  end
end

