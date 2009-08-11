module Globalize2
  module ApplicationControllerExtensions
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        before_filter :set_locale
      end
    end

    module InstanceMethods
      def set_locale
        @locale = params[:locale] || session[:locale] || Globalize2Extension.default_language

        session[:locale] = @locale
        I18n.locale = @locale
      end
      
      def reset_locale
        unless I18n.locale == Globalize2Extension.default_language
          locale = Globalize2Extension.default_language
          session[:locale] = locale
          I18n.locale = locale
          flash.now[:notice] = "The locale has been changed to default."
        end
      end
    end
  end
end