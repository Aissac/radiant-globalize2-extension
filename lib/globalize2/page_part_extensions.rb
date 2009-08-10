module Globalize2
  module PagePartExtensions
    def clone
      new_page_part = super
      globalize_translations.each do |t|
        new_page_part.globalize_translations << t.clone
      end
      new_page_part
    end
  end
end