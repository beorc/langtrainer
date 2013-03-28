FactoryGirl.define do
  factory :category do
    sequence(:title) {|n| "Category title #{n}" }

    ignore do
      forums_count 2
    end

    after(:create) do |category, evaluator|
      FactoryGirl.create_list(:forum, evaluator.forums_count, category: category)
    end
  end
end
