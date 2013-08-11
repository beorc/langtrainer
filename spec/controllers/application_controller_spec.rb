require 'spec_helper'

describe ApplicationController do

  context "when the HTTP_ACCEPT_LANGUAGE header is set to 'fr'" do
    before { set_http_accept_language_header 'fr-CA' }

    it "sets the locale to 'en'" do
      @controller.send :set_locale
      expect(I18n.locale).to eq(:en)
    end
  end

  context "when the HTTP_ACCEPT_LANGUAGE header is set to 'ru'" do
    before { set_http_accept_language_header 'ru-RU' }

    it "sets the locale to 'ru'" do
      @controller.send :set_locale
      expect(I18n.locale).to eq(:ru)
    end
  end

  context "when the HTTP_ACCEPT_LANGUAGE header is set to 'en'" do
    before { set_http_accept_language_header 'en-US' }

    it "sets the locale to 'en'" do
      @controller.send :set_locale
      expect(I18n.locale).to eq(:en)
    end
  end

  context "when the HTTP_ACCEPT_LANGUAGE header is all messed-up" do
    before { set_http_accept_language_header 'abcdef' }

    it "sets the locale to 'en'" do
      @controller.send :set_locale
      expect(I18n.locale).to eq(:en)
    end
  end

  def set_http_accept_language_header value
    @controller.class_eval do
      define_method :http_accept_language do
        HttpAcceptLanguage::Parser.new(value)
      end
    end
  end
end
