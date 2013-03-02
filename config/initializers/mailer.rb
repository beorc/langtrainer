require 'yaml'

path = File.join Rails.root, '/config/mailer.yml'
if File.exist? path
  config = YAML::load(File.open(path))[Rails.env]
  config.symbolize_keys!

  # Mail settings
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = config[:smtp_settings].symbolize_keys!

  ActionMailer::Base.default from: config[:from], reply_to: config[:reply_to]

  host = Rails.configuration.host
  Rails.configuration.action_mailer.default_url_options = { host: host }
  Rails.application.routes.default_url_options[:host] = host
  Rails.application.config.action_mailer.default_url_options = { host: host }
  ActionMailer::Base.default_url_options[:host] = host
end
