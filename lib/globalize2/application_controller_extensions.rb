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
        @locale = params[:locale] || session[:locale] || GLOBALIZE_BASE_LANGUAGE

        session[:locale] = @locale
        I18n.locale = @locale
      end
    end
  end
end