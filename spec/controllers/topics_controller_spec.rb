require 'spec_helper'

describe TopicsController do
  render_views

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin }
  let(:category) { FactoryGirl.create :category }
  let(:forum) { category.forums.first }
  let(:topic) { forum.topics.first }

  context 'for unauthorized' do
    it 'does not allow to get new' do
      get :new, forum_id: forum.id
      response.should redirect_to(login_path)
    end

    it 'does not allow to post create' do
      post :create, forum_id: forum.id, topic: { title: 'Topic title', body: 'Topic body' }
      response.should redirect_to(login_path)
    end

    it 'forbids to edit' do
      get :edit, id: topic.id
      response.should redirect_to(login_path)
    end

    it 'forbids to update' do
      put :update, id: topic.id, topic: { title: 'Corrected topic title' }
      response.should redirect_to(login_path)
    end

    it 'forbids to destroy' do
      delete :destroy, id: topic.id
      response.should redirect_to(login_path)
    end

    it 'allows to view' do
      get :show, id: topic.id
      response.should be_success
    end
  end

  describe 'for member' do
    before :each do
      login_user(user)
    end

    it 'allows to get new' do
      get :new, forum_id: forum.id
      response.should be_success
    end

    it 'allows to post create' do
      title = 'Topic title'
      body = 'Topic body'
      post :create, forum_id: forum.id, topic: { title: title, body: body }
      response.should redirect_to topic_path(Topic.unscoped.last)

      last = Topic.unscoped.last
      last.title.should == title
      last.forum.id.should == forum.id

      initial_post = last.posts.first
      initial_post.body.should == body
      initial_post.forum.id.should == forum.id
      initial_post.user.id.should == user.id
    end

    it 'forbids to edit alien ones' do
      get :edit, id: topic.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.topics.access_denied')
    end

    it 'allows to edit own ones' do
      own = FactoryGirl.create :topic, forum: forum, user: user
      get :edit, id: own.id
      response.should be_success
    end

    it 'forbids to update alien ones' do
      put :update, id: topic.id, topic: { title: 'Corrected topic title' }
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.topics.access_denied')
    end

    it 'allows to update own ones' do
      own = FactoryGirl.create :topic, forum: forum, user: user
      title = 'Corrected topic title'
      put :update, id: own.id, topic: { title: title }
      response.should redirect_to topic_path(own)

      updated = Topic.find(own.id)
      updated.title.should == title
    end

    it 'forbids to destroy' do
      delete :destroy, id: topic.id
      response.should redirect_to(root_path)
      flash[:alert].should == I18n.t('flash.topics.access_denied')
    end

    it 'allows to view' do
      get :show, id: topic.id
      response.should be_success
    end
  end

  context 'for admin' do
    before :each do
      login_user(admin)
    end

    it 'allows get new' do
      get :new, forum_id: forum.id
      response.should be_success
    end

    it 'allows post create' do
      title = 'Topic title'
      body = 'Topic body'
      post :create, forum_id: forum.id, topic: { title: title, body: body }
      response.should redirect_to topic_path(Topic.unscoped.last)

      last = Topic.unscoped.last
      last.title.should == title
      last.forum.id.should == forum.id

      initial_post = last.posts.first
      initial_post.body.should == body
      initial_post.forum.id.should == forum.id
      initial_post.user.id.should == admin.id
    end

    it 'allows to get edit' do
      get :edit, id: topic.id
      response.should be_success
    end

    it 'allows to put update' do
      title = 'Corrected topic title'
      put :update, id: topic.id, topic: { title: title }
      response.should redirect_to topic_path(topic)
      updated = Topic.find(topic.id)
      updated.title.should == title
    end

    it 'allows to destroy' do
      delete :destroy, id: topic.id
      response.should redirect_to forum_url(forum)
      Topic.where(id: topic.id).empty?.should == true
    end

    it 'allows to view' do
      get :show, id: topic.id
      response.should be_success
    end
  end
end

