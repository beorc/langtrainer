require 'spec_helper'

describe CategoriesController do
  render_views

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let(:new_category) { FactoryGirl.create :category }

  context 'for unauthorized' do
    it 'forbids to create new one' do
      get :new
      response.should redirect_to(login_path)
      post :create, title: 'Category title'
      response.should redirect_to(login_path)
    end

    it 'forbids to update' do
      put :update, id: new_category.id, title: 'Corrected category title'
      response.should redirect_to(login_path)
    end

    it 'forbids to destroy' do
      delete :destroy, id: new_category.id
      response.should redirect_to(login_path)
    end
  end

  describe 'for member' do

    it 'does not allow to create new one' do
      login_user(user)
      get :new
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.categories.access_denied')
    end

    it 'does not allow to create public sentence' do
      login_user(@user)
      post :create, sentence: { en: 'English text', exercise_id: @public_exercise.id }
      response.should be_redirect
    end

    it 'allows to create own sentence' do
      login_user(@user)
      text = 'English text'
      post :create, sentence: { en: text, exercise_id: @public_exercise.id }
      response.should redirect_to(users_sentences_path(sentence: Sentence.last))
      Sentence.last.en.should == text
    end

    it 'allows to update own sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @user
      text = 'new english text'
      put :update, id: sentence.id, sentence: { en: text }
      response.should redirect_to(users_sentences_path(sentence: sentence))
      Sentence.find(sentence.id).en.should == text
    end

    it 'forbids to update alien sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @another_user
      text = 'new english text'
      put :update, id: sentence.id, sentence: { en: text }
      response.status.should == 302
      Sentence.find(sentence.id).en.should_not == text
    end

    it 'forbids to update public sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise
      text = 'new english text'
      put :update, id: sentence.id, sentence: { en: text }
      response.status.should == 302
      Sentence.find(sentence.id).en.should_not == text
    end

    it 'allows to destroy own sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @user
      delete :destroy, id: sentence.id
      response.should redirect_to(users_sentences_path)
      Sentence.where(id: sentence.id).empty?.should == true
    end

    it 'forbids to destroy alien sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise, owner: @another_user
      delete :destroy, id: sentence.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/sentences.access_denied')
      Sentence.where(id: sentence.id).empty?.should == false
    end

    it 'forbids to destroy public sentence' do
      login_user(@user)
      sentence = FactoryGirl.create :sentence, exercise: @public_exercise
      delete :destroy, id: sentence.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/sentences.access_denied')
      Sentence.where(id: sentence.id).empty?.should == false
    end
  end

  context 'for admin' do
    before :all do
      @admin = FactoryGirl.create :admin
    end

    it 'allows to create' do
      login_user(@admin)
      text = 'English text'
      post :create, sentence: { en: text, exercise_id: @public_exercise.id }
      response.should redirect_to(users_sentences_path(sentence: Sentence.last))
      Sentence.last.en.should == text
    end

    it 'allows to update' do
      login_user(@admin)
      sentence = @public_exercise.sentences.first
      text = 'new english text'
      put :update, id: sentence.id, sentence: { en: text }
      response.should redirect_to(users_sentences_path(sentence: sentence))
      Sentence.find(sentence.id).en.should == text
    end

    it 'allows to destroy' do
      login_user(@admin)
      sentence = @public_exercise.sentences.first
      delete :destroy, id: sentence.id
      response.should redirect_to(users_sentences_path)
      Sentence.where(id: sentence.id).empty?.should == true
    end
  end
end

