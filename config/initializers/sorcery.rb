Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|
  host = Rails.configuration.host
  oauth_providers = Rails.application.config.oauth_providers

  config.external_providers = [:twitter, :facebook, :google]

  config.twitter.key = oauth_providers['twitter']['key']
  config.twitter.secret = oauth_providers['twitter']['secret']
  config.twitter.callback_url = "http://#{host}/oauth/callback?provider=twitter"
  config.twitter.user_info_mapping = {:username => "screen_name"}

  #config.facebook.key = oauth_providers['facebook']['key']
  #config.facebook.secret = oauth_providers['facebook']['secret']
  #config.facebook.callback_url = "http://#{host}/oauth/callback?provider=facebook"
  #config.facebook.user_info_mapping = {:username => "name"}

  config.google.key = oauth_providers['google']['key']
  config.google.secret = oauth_providers['google']['secret']
  config.google.callback_url = "http://#{host}/oauth/callback?provider=google"
  config.google.user_info_mapping = {:username => "name"}

  config.user_config do |user|
    user.username_attribute_names                      = [:email]
    user.subclasses_inherit_config                    = true
    user.authentications_class                        = UserProvider
  end

  config.user_class = User
end
