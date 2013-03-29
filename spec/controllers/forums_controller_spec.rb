require 'spec_helper'

describe ForumsController do
  render_views

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let(:category) { FactoryGirl.create :category }
  let(:forum) { category.forums.first }

  context 'for unauthorized' do
    it 'does not allow to get new' do
      get :new
      response.should redirect_to(login_path)
    end

    it 'does not allow to post create' do
      post :create, forum: { title: 'Forum title', description: 'Forum description', category_id: category.id }
      response.should redirect_to(login_path)
    end

    it 'forbids to edit' do
      get :edit, id: forum.id
      response.should redirect_to(login_path)
    end

    it 'forbids to update' do
      put :update, id: forum.id, forum: { title: 'Corrected forum title' }
      response.should redirect_to(login_path)
    end

    it 'forbids to destroy' do
      delete :destroy, id: forum.id
      response.should redirect_to(login_path)
    end

    it 'allows to view' do
      get :show, id: forum.id
      response.should be_success
    end
  end

  describe 'for member' do
    before :each do
      login_user(user)
    end

    it 'does not allow to get new' do
      get :new
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.forums.access_denied')
    end

    it 'does not allow to post create' do
      post :create, forum: { title: 'Forum title', description: 'Forum description', category_id: category.id }
      flash[:alert].should == I18n.t('flash.forums.access_denied')
    end

    it 'forbids to edit' do
      get :edit, id: forum.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.forums.access_denied')
    end

    it 'forbids to update' do
      put :update, id: forum.id, forum: { title: 'Corrected forum title' }
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.forums.access_denied')
    end

    it 'forbids to destroy' do
      delete :destroy, id: forum.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.forums.access_denied')
    end

    it 'allows to view' do
      get :show, id: forum.id
      response.should be_success
    end
  end

  context 'for admin' do
    before :each do
      login_user(admin)
    end

    it 'allows get new' do
      get :new
      response.should be_success
    end

    it 'allows post create' do
      title = 'Forum title'
      description = 'Forum description'
      post :create, forum: { title: title, description: description, category_id: category.id }
      response.should redirect_to forums_path

      last_forum = Forum.unscoped.last
      last_forum.title.should == title
      last_forum.description.should == description
      last_forum.category.id.should == category.id
    end

    it 'allows to get edit' do
      get :edit, id: forum.id
      response.should be_success
    end

    it 'allows to put update' do
      title = 'Corrected forum title'
      put :update, id: forum.id, forum: { title: title }
      response.should redirect_to forum_path(forum)
      updated = Forum.where(id: forum.id).first
      updated.title.should == title
    end

    it 'allows to destroy' do
      delete :destroy, id: forum.id
      response.should redirect_to forums_url
      Forum.where(id: forum.id).empty?.should == true
    end

    it 'allows to view' do
      get :show, id: forum.id
      response.should be_success
    end
  end
end

