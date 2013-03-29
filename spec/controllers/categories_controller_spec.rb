require 'spec_helper'

describe CategoriesController do
  render_views

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let(:new_category) { FactoryGirl.create :category }

  context 'for unauthorized' do
    it 'does not allow to get new' do
      get :new
      response.should redirect_to(login_path)
    end

    it 'does not allow to post create' do
      post :create, category: { title: 'Category title' }
      response.should redirect_to(login_path)
    end

    it 'forbids to edit' do
      get :edit, id: new_category.id
      response.should redirect_to(login_path)
    end

    it 'forbids to update' do
      put :update, id: new_category.id, category: { title: 'Corrected category title' }
      response.should redirect_to(login_path)
    end

    it 'forbids to destroy' do
      delete :destroy, id: new_category.id
      response.should redirect_to(login_path)
    end

    it 'allows to view' do
      get :index
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
      flash[:alert].should == I18n.t('flash.categories.access_denied')
    end

    it 'does not allow to post create' do
      post :create, category: { title: 'Category title' }
      flash[:alert].should == I18n.t('flash.categories.access_denied')
    end

    it 'forbids to edit' do
      get :edit, id: new_category.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.categories.access_denied')
    end

    it 'forbids to update' do
      put :update, id: new_category.id, title: 'Corrected category title'
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.categories.access_denied')
    end

    it 'forbids to destroy' do
      delete :destroy, id: new_category.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.categories.access_denied')
    end

    it 'allows to view' do
      get :index
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
      title = 'Category title'
      post :create, category: { title: title }
      response.status.should == 302
      Category.last.title.should == title
    end

    it 'allows to get edit' do
      get :edit, id: new_category.id
      response.should be_success
    end

    it 'allows to put update' do
      title = 'Corrected category title'
      put :update, id: new_category.id, category: { title: title }
      response.should redirect_to forums_path
      updated = Category.where(id: new_category.id).first
      updated.title.should == title
    end

    it 'allows to destroy' do
      delete :destroy, id: new_category.id
      response.should redirect_to forums_url
      Category.where(id: new_category.id).empty?.should == true
    end

    it 'allows to view' do
      get :index
      response.should be_success
    end
  end
end

