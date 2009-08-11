module Globalize2::Compatibility
  module CopyMove::CopyMoveControllerExtensions
    def self.included(base)
      base.class_eval do
        before_filter :reset_locale
        alias_method :old_suggest_title_and_slug_for_new_page, :suggest_title_and_slug_for_new_page
    
        def suggest_title_and_slug_for_new_page(page, parent)    
          new_title, new_slug, i = '', '', 0
          loop do
            case i
            when 0 then new_title = page.title; new_slug = page.slug
            when 1 then new_title = "#{page.title} (Copy)"; new_slug = "#{page.slug}-#{i+1}"
            else new_title = "#{page.title} (Copy #{i})"; new_slug = "#{page.slug}-#{i+1}"
            end
            break unless Page.find(:first, :joins => "INNER JOIN page_translations on page_translations.page_id = pages.id", :conditions => ["pages.parent_id = ? AND page_translations.slug = ?", parent.id, new_slug])
            i += 1
          end
          return new_title, new_slug
        end
      end
    end
  end
end