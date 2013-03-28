FactoryGirl.define do
  factory :post do
    sequence(:body) {|n| "Post body #{n}" }
  end
end
