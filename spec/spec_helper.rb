# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'
require 'rspec/autorun'
require 'factory_girl_rails'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../../db/migrate/", __FILE__)

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include RSpec::Matchers
  config.include Sorcery::TestHelpers::Rails

  FactoryGirl.definition_file_paths << File.expand_path("../factories", __FILE__)
  #FactoryGirl.find_definitions

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Capybara::DSL
  Capybara.current_driver = :selenium

  config.before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation

    FactoryGirl.create :role
    FactoryGirl.create_list :exercise, 3
  end

  config.before(:each) do
    Delayed::Worker.delay_jobs = false
    if example.metadata[:js]
      Capybara.current_driver = :selenium
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    Capybara.use_default_driver if example.metadata[:js]
    DatabaseCleaner.clean
  end
end

def sign_in_by_email(email = 'beorc@httplab.ru')
  visit new_user_session_path
  fill_in('user[email]', with: email)
  click_on 'send_token_button'
  user = User.find_by_email email
  visit root_path(auth_token: user.authentication_token)
  user
end

def sign_in_as_admin
  admin = FactoryGirl.create :admin
  sign_in_by_email(admin.email)
end

def check_alert(text)
  page.driver.browser.switch_to.alert.text.should eq text
  page.driver.browser.switch_to.alert.accept
end
