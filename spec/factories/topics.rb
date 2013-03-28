FactoryGirl.define do
  factory :topic do
    sequence(:title) {|n| "Topic title #{n}" }
    sequence(:body) {|n| "Topic body #{n}" }

    ignore do
      posts_count 2
    end

    after(:create) do |topic, evaluator|
      user = FactoryGirl.create :user
      FactoryGirl.create_list(:post, evaluator.posts_count, forum: topic.forum, topic: topic, user: user)
    end
  end
end
