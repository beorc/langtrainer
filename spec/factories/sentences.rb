# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sentence do
    content "MyString"
    language nil
    template "MyString"
  end
end
