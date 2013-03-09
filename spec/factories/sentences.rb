# encoding: UTF-8

FactoryGirl.define do
  factory :sentence do
    sequence(:en) {|n| "Test sentence #{n}" }
    sequence(:ru) {|n| "Тестовое предложение #{n}" }
    atom false

    factory :correction do
      type 'Correction'
    end
  end
end
