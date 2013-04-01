require 'oauth2'
class OauthsController < ApplicationController
  skip_before_filter :require_login

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def login_at(provider_name, args = {})
    provider = Config.send(provider_name)

    uri = URI.parse(request.url.gsub(/\?.*$/,''))
    uri.path = ''
    uri.query = nil
    uri.scheme = 'https' if(request.env['HTTP_X_FORWARDED_PROTO'] == 'https')
    if provider_name.to_s == 'google'
      host = 'http://langtrainer.com'
    else
      host = uri.to_s
    end
    provider.callback_url = "#{host}/oauth/callback?provider=#{provider_name}"

    if provider.has_callback?
      redirect_to provider.login_url(params,session)
    else
      #provider.login(args)
    end
  end

  def oauth
    login_at(params[:provider])
  end

  def create_from(provider_name)
    user = super
    user.after_oauth_sign_in!
    user
  end

  def callback
    provider = params[:provider]
    begin
    if @user = login_from(provider)
      redirect_to root_path, :notice => t('flash.oauths.logged_in', provider: provider.titleize)
    else
      begin
        @user = create_from(provider)
        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, :notice => t('flash.oauths.logged_in', provider: provider.titleize)
      rescue => e
        logger.error "==Oauth Error== #{e.message}"
        logger.error e.backtrace.join("\n")
        redirect_to root_path, :alert => t('flash.oauths.error', provider: provider.titleize)
      end
    end
    rescue ::OAuth2::Error => e
      p e
      puts e.code
      puts e.description
      puts e.message
      puts e.backtrace
    end
  end
end
