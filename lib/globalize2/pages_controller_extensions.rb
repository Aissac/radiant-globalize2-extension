module Globalize2
  module PagesControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :reset_locale, :only => [:new]
      end
    end
  end
end