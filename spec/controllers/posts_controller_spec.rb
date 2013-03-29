require 'spec_helper'

describe PostsController do
  render_views

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let(:category) { FactoryGirl.create :category }
  let(:forum) { category.forums.first }
  let(:topic) { forum.topics.first }
  let(:new_post) { topic.posts.first }

  context 'for unauthorized' do
    it 'does not allow to get new' do
      get :new, topic_id: topic.id
      response.should redirect_to(login_path)
    end

    it 'does not allow to post create' do
      post :create, topic_id: topic.id, :post => { body: 'Post body' }
      response.should redirect_to(login_path)
    end

    it 'forbids to edit' do
      get :edit, id: new_post.id
      response.should redirect_to(login_path)
    end

    it 'forbids to update' do
      put :update, id: new_post.id, :post => { body: 'Corrected post body' }
      response.should redirect_to(login_path)
    end

    it 'forbids to destroy' do
      delete :destroy, id: new_post.id
      response.should redirect_to(login_path)
    end
  end

  describe 'for member' do
    before :each do
      login_user(user)
    end

    it 'allows to get new' do
      get :new, topic_id: topic.id
      response.should be_success
    end

    it 'allows to post create' do
      body = 'Post body'
      post :create, topic_id: topic.id, :post => { body: body }
      response.should redirect_to topic_path(topic)

      last = Post.unscoped.last
      last.body.should == body
      last.topic.id.should == topic.id
    end

    it 'forbids to edit alien ones' do
      get :edit, id: new_post.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.posts.access_denied')
    end

    it 'allows to edit own ones' do
      own = FactoryGirl.create :post, forum: forum, topic: topic, user: user
      get :edit, id: own.id
      response.should be_success
    end

    it 'forbids to update alien ones' do
      put :update, id: new_post.id, :post => { body: 'Corrected topic body' }
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.posts.access_denied')
    end

    it 'allows to update own ones' do
      own = FactoryGirl.create :post, forum: forum, topic: topic, user: user
      body = 'Corrected topic body'
      put :update, id: own.id, :post => { body: body }
      response.should redirect_to topic_path(own.topic)

      updated = Post.find(own.id)
      updated.body.should == body
    end

    it 'forbids to destroy alien' do
      delete :destroy, id: new_post.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.posts.access_denied')
    end

    it 'allows to destroy own' do
      own = FactoryGirl.create :post, forum: forum, topic: topic, user: user
      delete :destroy, id: own.id
      response.should redirect_to topic_url(topic)
      Post.where(id: own.id).empty?.should == true
    end
  end

  context 'for admin' do
    before :each do
      login_user(admin)
    end

    it 'allows get new' do
      get :new, topic_id: topic.id
      response.should be_success
    end

    it 'allows post create' do
      body = 'Post body'
      post :create, topic_id: topic.id, :post => { body: body }
      response.should redirect_to topic_path(topic)

      last = Post.unscoped.last
      last.body.should == body
      last.topic.id.should == topic.id
    end

    it 'allows to get edit' do
      get :edit, id: new_post.id
      response.should be_success
    end

    it 'allows to put update' do
      body = 'Corrected topic body'
      put :update, id: new_post.id, :post => { body: body }
      response.should redirect_to topic_path(topic)
      updated = Post.find(new_post.id)
      updated.body.should == body
    end

    it 'allows to destroy' do
      delete :destroy, id: new_post.id
      response.should redirect_to topic_url(topic)
      Post.where(id: new_post.id).empty?.should == true
    end
  end
end

