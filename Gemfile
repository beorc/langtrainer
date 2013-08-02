source 'https://rubygems.org'
gem 'rails', '~> 3.2.11'
gem 'mysql2'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '>= 2.2.2.0'
  gem 'uglifier', '>= 1.0.3'
  gem 'font-awesome-sass-rails'
  gem 'asset_sync'
end
gem 'jquery-rails'
gem 'sorcery'
gem 'cancan', '>= 1.6.8'
gem 'rolify', '>= 3.2.0'
gem 'simple_form', '>= 2.0.4'
gem 'figaro', '>= 0.5.3'
gem 'slim-rails'
gem 'gon'
gem 'kaminari'
gem 'meta-tags', require: 'meta_tags'
gem 'unicode'
gem 'russian', '~> 0.6.0'
gem 'has_scope'
gem 'hashie'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'compass-rails'
gem 'virtus'
gem 'validates_existence', '>= 0.4'
gem 'friendly_id', '~> 4.0.9'
gem 'http_accept_language', git: 'git://github.com/iain/http_accept_language.git'
gem 'talky', git: 'git@github.com:beorc/talky.git', branch: 'master'

group :development, :test do
  gem 'factory_girl_rails', '>= 4.2.0'
  gem 'rspec-rails', '>= 2.12.2'

  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
  gem 'capistrano-unicorn', git: 'git://github.com/sosedoff/capistrano-unicorn.git'
  gem 'capistrano_colors'
end

group :production do
  gem 'unicorn'
  gem 'exception_notification'
  gem 'whenever', :require => false
  gem 'db2fog'
end

group :development do
  gem 'quiet_assets', '>= 1.0.1'
  gem 'better_errors', '>= 0.3.2'
  gem 'binding_of_caller', '>= 0.6.8'
  gem 'letter_opener'
end

group :test do
  gem 'database_cleaner', '>= 0.9.1'
  gem 'email_spec', '>= 1.4.0'
  gem 'launchy', '>= 2.1.2'
  gem 'capybara', '>= 2.0.2'
end
