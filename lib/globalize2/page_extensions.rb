module Globalize2
  module PageExtensions
    def self.included(base)
      base.reflections[:children].options[:order] = 'pages.virtual DESC'
      base.validate.delete_if { |v| v.options[:scope] == :parent_id }
      base.send(:validate, :unique_slug)
    end
    
    def unique_slug
      if self.class.find(:first, :joins => "INNER JOIN page_translations on page_translations.page_id = pages.id", :conditions => ["pages.parent_id = ? AND page_translations.slug = ? AND page_translations.locale = ? AND page_translations.page_id <> ?", parent_id, slug, self.class.locale, id])
        errors.add('slug', "must be unique")
      end
    end
  end
end