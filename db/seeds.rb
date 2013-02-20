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

require 'yaml'

files = Dir[File.join(Rails.root, "db", "default", "*.yml")]
files.sort {|f1, f2| File.basename(f1) <=> File.basename(f2)}.each do |file|
  puts "Loading data from #{File.basename(file)}"
  sentences = YAML::load(File.open(file, 'r'))
  sentences.each do |sentence|
    Sentence.find_or_create_by_content( content: sentence['content'],
                                                        language_id: sentence['language_id'],
                                                        template: sentence['template'] )
  end
  puts "Loaded sentences: #{sentences.count}"
end
