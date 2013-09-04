# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :users_course, :class => 'Users::Course' do
    slug "MyString"
    title "MyString"
    description "MyText"
  end
end
