module Globalize2
  module PagesControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :reset_locale, :only => [:new]
      end
    end
    
    def reset_locale
      locale = GLOBALIZE_BASE_LANGUAGE
      session[:locale] = locale
      I18n.locale = locale
      flash.now[:notice] = "The locale has been changed to the default locale."
    end
  end
end