require 'spec_helper'

describe Users::ExercisesController do
  render_views

  before :all do
    FactoryGirl.create :role

    @user = FactoryGirl.create :user
    @another_user = FactoryGirl.create :user
    @public_exercise = FactoryGirl.create :exercise
    @alien_exercise = FactoryGirl.create :exercise, owner: @another_user
  end

  context 'for member' do

    it 'does not allow to GET new with maximum exercises created' do
      FactoryGirl.create_list :exercise, User::EXERCISES_MAX, owner: @user
      login_user(@user)
      get :new
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/exercises.access_denied')
      #response.status.should be 200
      #assigns(:user).new_record?.should be true

      #sign_in User.last
      #lambda do
        #post :create, provider: :twitter
      #end.should change(Authentication, :count).by(1)
      #response.should redirect_to(edit_user_registration_path)
      #subject.current_user.username.should == 'tester'
    end

    it 'allows to GET new with less then maximum exercises created' do
      login_user(@user)
      get :new
      response.status.should be 200
      assigns(:exercise).new_record?.should be true
    end

    it 'checks rights to edit public exercise' do
      login_user(@user)
      get :edit, id: @public_exercise
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/exercises.access_denied')
    end

    it 'checks rights to edit own exercise' do
      own_exercise = FactoryGirl.create :exercise, owner: @user
      login_user(@user)
      get :edit, id: own_exercise
      response.status.should be 200
    end

    it 'checks rights to edit alien exercise' do
      login_user(@user)
      get :edit, id: @alien_exercise
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/exercises.access_denied')
    end

    it 'checks rights to destroy public exercise' do
      login_user(@user)
      get :destroy, id: @public_exercise
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/exercises.access_denied')
    end

    it 'checks rights to destroy own exercise' do
      own_exercise = FactoryGirl.create :exercise, owner: @user
      login_user(@user)
      get :destroy, id: own_exercise
      response.status.should be 302
      Exercise.where(id: own_exercise.id).count.should be 0
    end

    it 'checks rights to destroy alien exercise' do
      login_user(@user)
      get :destroy, id: @alien_exercise
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.users/exercises.access_denied')
    end

    it 'allows to create own exercise' do
      login_user(@user)
      title = 'Own exercise'
      post :create, exercise: { title: title }
      response.status.should be 302
      exercise = Exercise.last
      exercise.title.should == title
      exercise.owner.id.should == @user.id
    end

    it 'allows to update own exercise' do
      own_exercise = FactoryGirl.create :exercise, owner: @user
      login_user(@user)
      title = 'New exercise title'
      put :update, id: own_exercise.id, exercise: { title: title }
      response.should redirect_to(users_exercises_path)
      Exercise.find(own_exercise.id).title.should == title
    end
  end

  context 'for admin' do
    before :all do
      @admin = FactoryGirl.create :admin
    end

    it 'allows to GET new always for admin' do
      login_user(@admin)
      get :new
      response.status.should be 200
      assigns(:exercise).new_record?.should be true
    end

    it 'allows to edit public exercise' do
      login_user(@admin)
      get :edit, id: @public_exercise
      response.status.should be 200
    end

    it 'allows to edit alien exercise' do
      login_user(@admin)
      get :edit, id: @alien_exercise
      response.status.should be 200
    end

    it 'allows to destroy public exercise' do
      login_user(@admin)
      get :destroy, id: @public_exercise
      response.status.should be 302
      Exercise.where(id: @public_exercise.id).count.should be 0
    end

    it 'allows to destroy alien exercise' do
      login_user(@admin)
      get :destroy, id: @alien_exercise
      response.status.should be 302
      Exercise.where(id: @alien_exercise.id).count.should be 0
    end

    it 'allows to create public exercise' do
      login_user(@admin)
      @admin.exercises.destroy_all
      title = 'Public exercise'
      get :create, exercise: { title: title }
      response.status.should be 302
      exercise = Exercise.last
      exercise.title.should == title
      exercise.owner.should be nil
    end
  end
end
