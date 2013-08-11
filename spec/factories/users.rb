# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name 'member'
  end

  factory :user do |user|
    sequence(:username) {|n| "User_#{n}" }
    sequence(:email) {|n| "beorc_#{n}@gmail.com" }
    language_id Language.first.id
  end

  factory :user_with_email, class: :User do |user|
    email 'bairkan@gmail.com'
  end

  factory :user_without_email, class: :User do |user|
    username 'user'
  end

  factory :user_without_language, class: :User do |user|
    username 'without language'
  end

  factory :admin, class: :User do
    username 'admin'
    email 'bairkan@gmail.com'
    after(:create) do |user|
      FactoryGirl.create_list(:role, 1, name: 'admin', users: [user])
    end
  end
end
