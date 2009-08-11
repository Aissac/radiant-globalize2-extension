module Globalize2
  module SiteControllerExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :find_page, :globalize
      end
    end
    
    def find_page_with_globalize(url)
      globalized_url = '/' + I18n.locale + '/' + url
      find_page_without_globalize(globalized_url)
    end
  end
end