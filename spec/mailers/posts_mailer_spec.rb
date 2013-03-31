require "spec_helper"

describe PostsMailer do

  let(:admin) { FactoryGirl.create :user_with_email }
  let(:category) { FactoryGirl.create :category }
  let(:forum) { category.forums.first }
  let(:topic) { forum.topics.first }
  let(:new_post) { topic.posts.first }
  let(:user) { new_post.user }
  let(:email) do
    PostsMailer.send_notification_email([admin.email], post_url_options: { id: new_post.to_param },
                                                       topic_url_options: { id: topic.to_param },
                                                       topic: topic.title,
                                                       user: user.title,
                                                       message: new_post.body)
  end

  before(:each) do
  end

  it "should generate proper message" do
    email.should have_subject(I18n.t('mailer.posts.subject'))

    post_url = edit_post_url(new_post)
    topic_url = topic_url(topic)

    email.should have_body_text(topic.user.title)
    email.should have_body_text(topic.title)
    email.should have_body_text(new_post.body)
    email.should have_body_text(post_url)
    email.should have_body_text(topic_url)
  end

  it "should deliver successfully" do
    lambda { email.deliver }.should_not raise_error
  end

  describe "and delivered" do
    it "should be added to the delivery queue" do
      lambda { email.deliver! }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end
  end
end
