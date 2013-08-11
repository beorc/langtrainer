
FactoryGirl.define do
  sequence(:slug) {|n| "exercise-#{n}" }

  factory :exercise do
    slug

    ignore do
      sentences_count 2
    end

    after(:create) do |exercise, evaluator|
      user = FactoryGirl.create :user
      FactoryGirl.create_list(:sentence, evaluator.sentences_count, exercise: exercise)
      FactoryGirl.create_list(:sentence, evaluator.sentences_count, exercise: exercise, owner: user)
      FactoryGirl.create_list(:correction, 1, exercise: exercise, sentence: exercise.sentences.first, owner: user)
    end
  end
end
