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

#puts 'DEFAULT USERS'

#user = User.find_or_create_by_email :email => ENV['MEMBER_EMAIL'].dup, :password => ENV['MEMBER_PASSWORD'].dup, :password_confirmation => ENV['MEMBER_PASSWORD'].dup
#puts 'user: ' << user.email
#user.add_role :member

#user = User.find_or_create_by_email :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#puts 'user: ' << user.email
#user.add_role :admin

#require 'yaml'

#files = Dir[File.join(Rails.root, "db", "default", "*.yml")]
#files.sort {|f1, f2| File.basename(f1) <=> File.basename(f2)}.each do |file|
  #puts "Loading data from #{File.basename(file)}"
  #sentences = YAML::load(File.open(file, 'r'))
  #sentences.each do |sentence|
    #created_sentence = Sentence.find_or_create_by_english_and_russian_and_exercise_id( english: sentence['english'],
                                                                                       #russian: sentence['russian'],
                                                                                       #exercise_id: sentence['exercise_id'] )
    #raise "Sentence not created: #{sentence.inspect}: #{created_sentence.errors.messages.inspect}" unless created_sentence.valid?
  #end
  #puts "Loaded sentences: #{sentences.count}"
#end
