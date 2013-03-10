require 'spec_helper'

describe Users::CorrectionsController do
  render_views

  before :all do
    FactoryGirl.create :role

    @user = FactoryGirl.create :user
    @another_user = FactoryGirl.create :user
    @public_exercise = FactoryGirl.create :exercise
    @own_exercise = FactoryGirl.create :exercise, owner: @user
    @alien_exercise = FactoryGirl.create :exercise, owner: @another_user
  end

  context 'for unauthorized' do
    it 'forbids to create for public sentence' do
      sentence = @public_exercise.sentences.first
      post :create, format: :json, sentence_id: sentence.id, en: 'Corrected english text'
      response.should redirect_to(login_path)
    end

    it 'forbids to create for user sentence' do
      sentence = @alien_exercise.sentences.first
      post :create, format: :json, sentence_id: sentence.id, en: 'Corrected english text'
      response.should redirect_to(login_path)
    end
  end

  context 'for member' do
    it 'allows to create for public sentence' do
      login_user(@user)
      sentence = @public_exercise.sentences.first
      post :create, format: :json, sentence_id: sentence.id, en: 'Corrected english text'
      response.should be_success
      body = JSON.parse(response.body)
      body.should include('id')
      body.should include('url')
      body.should include('method')
    end

    it 'forbids to create for alien sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, owner: @another_user, exercise: @public_exercise
      post :create, format: :json, sentence_id: sentence.id, en: 'Corrected english text'
      response.should_not be_success
    end
  end

  context 'for admin' do
    before :all do
      @admin = FactoryGirl.create :admin
    end

    it 'forbids to create' do
      login_user(@admin)
      sentence = @public_exercise.sentences.first
      post :create, format: :json, sentence_id: sentence.id, en: 'Corrected english text'
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/corrections.access_denied')
    end
  end
end
