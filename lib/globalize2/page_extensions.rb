module Globalize2
  module PageExtensions
    def self.included(base)
      base.validate.delete_if { |v| v.options[:scope] == :parent_id }
      base.send(:validate, :unique_slug)
      base.reflections[:children].options[:order] = 'pages.virtual DESC'
      
      base.class_eval do
        alias_method_chain 'tag:link', :globalize
        alias_method_chain :relative_url_for, :globalize
        alias_method_chain :update_globalize_record, :reset
        attr_accessor :reset_translations
      end
    end
    
    def unique_slug
      if self.class.find(:first, :joins => "INNER JOIN page_translations on page_translations.page_id = pages.id", :conditions => ["pages.parent_id = ? AND page_translations.slug = ? AND page_translations.locale = ? AND page_translations.page_id <> ?", parent_id, slug, self.class.locale, id])
        errors.add('slug', "must be unique")
      end
    end

    def update_globalize_record_with_reset
      if reset_translations && I18n.locale != GLOBALIZE_BASE_LANGUAGE
        self.globalize_translations.find_by_locale(I18n.locale).destroy
        parts.each do |part|
          part.globalize_translations.find_by_locale(I18n.locale).destroy
        end
      else
        update_globalize_record_without_reset
      end
    end
   
    def relative_url_for_with_globalize(*args)
      '/' + I18n.locale + relative_url_for_without_globalize(*args)
    end 
  end
end