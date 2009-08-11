module Globalize2::Compatibility
  module Paginate::GlobalizeTags
    include Radiant::Taggable
  
    class TagError < StandardError; end
    
    tag 'paginate_with_globalize' do |tag|
      with_translated_locales = tag.attr['locale'] == 'false' ? false : true
      if with_translated_locales
        result = Page.scope_locale(I18n.locale) do
          send('tag:paginate_without_globalize', tag)
        end
      else
        result = send('tag:paginate_without_globalize', tag)
      end
      result
    end
  end
end