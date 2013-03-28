FactoryGirl.define do
  factory :category do
    sequence(:title) {|n| "Category title #{n}" }
  end
end
