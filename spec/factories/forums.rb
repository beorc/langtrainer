FactoryGirl.define do
  factory :forum do
    sequence(:title) {|n| "Forum title #{n}" }
    sequence(:description) {|n| "Forum description #{n}" }

    ignore do
      topics_count 2
    end

    after(:create) do |forum, evaluator|
      user = FactoryGirl.create :user
      FactoryGirl.create_list(:topic, evaluator.topics_count, forum: forum, user: user)
    end
  end
end
