module Globalize2::Compatibility
  module CopyMove::CopyMoveModelExtensions
    def self.included(base)
      base.class_eval do        
        alias_method :old_copy_to, :copy_to
    
        def copy_to(parent, status = nil)
          parent.children.build(copiable_attributes.symbolize_keys.merge(new_slug_and_title_under(parent))).tap do |new_page|
            self.globalize_translations.each do |gt|
              new_page.globalize_translations << gt.clone
            end
            self.parts.each do |part|
              new_page.parts << part.clone
            end
            new_page.status_id = status.blank? ? new_page.status_id : status
            new_page.save!
          end
        end
      end
    end
  end
end