# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_confirmation do
    new_email 'bairkan@gmail.com'
  end
end
