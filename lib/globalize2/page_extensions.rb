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

        alias_method_chain 'tag:paginate', :globalize if defined?(PaginateExtension)
        
        def self.scope_locale(locale, &block)
          with_scope(:find => { :joins => "INNER JOIN page_translations on page_translations.page_id = pages.id", :conditions => ['page_translations.locale = ?', locale] }) do
            yield
          end
        end
      end
    end
    
    def unique_slug      
      options = {
        "pages.parent_id = ?" => parent_id,
        "page_translations.slug = ?" => slug,
        "page_translations.locale = ?" => self.class.locale,
        "page_translations.page_id <> ?" => id
      }
      
      conditions_str = []
      conditions_arg = []
      
      options.each do |key, value|
        if value != nil
          conditions_str << key
          conditions_arg << value
        else
          conditions_str << "page_translations.page_id IS NOT NULL"
        end
      end
      
      conditions = [conditions_str.join(" AND "), *conditions_arg]
      
      if self.class.find(:first, :joins => "INNER JOIN page_translations on page_translations.page_id = pages.id", :conditions => conditions )
        errors.add('slug', "must be unique")
      end
      
    end

    def update_globalize_record_with_reset
      if reset_translations && I18n.locale != Globalize2Extension.default_language
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