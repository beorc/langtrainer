# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'ROLES'

[:admin, :member].each do |name|
  puts name
  Role.find_or_create_by_name(name: name)
end

puts 'DEFAULT USERS'

user = User.find_or_create_by_email :email => ENV['MEMBER_EMAIL'].dup
puts 'user: ' << user.email
user.add_role :member

user = User.find_or_create_by_email :email => ENV['ADMIN_EMAIL'].dup
puts 'user: ' << user.email
user.add_role :admin

puts 'EXERCISES'
[:first, :second, :third, :fourth, :fifth, :sixth, :seventh, :eighth, :ninth, :tenth, :eleventh, :twelfth, :thirteenth].each do |slug|
  exercise = Exercise.find_or_create_by_slug(slug: slug, title: "#{slug.to_s.capitalize} exercise")
  raise "Exercise not created: #{slug}: #{exercise.errors.messages.inspect}" unless exercise.valid?
end

require 'yaml'

files = Dir[File.join(Rails.root, "db", "default", "*.yml")]
files.sort {|f1, f2| File.basename(f1) <=> File.basename(f2)}.each do |file|
  puts "Loading data from #{File.basename(file)}"
  sentences = YAML::load(File.open(file, 'r'))
  sentences.each do |sentence|
    created_sentence = Sentence.find_or_create_by_en_and_ru_and_exercise_id( en: sentence['english'],
                                                                             ru: sentence['russian'],
                                                                             exercise_id: Exercise.find(sentence['exercise']).id,
                                                                             atom: sentence['atom'] )
    raise "Sentence not created: #{sentence.inspect}: #{created_sentence.errors.messages.inspect}" unless created_sentence.valid?
  end
  puts "Loaded sentences: #{sentences.count}"
end
