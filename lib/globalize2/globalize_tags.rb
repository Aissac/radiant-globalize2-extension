module Globalize2
  module GlobalizeTags  
    include Radiant::Taggable
  
    class TagError < StandardError; end
    
    tag 'link_with_globalize' do |tag|
      locale = tag.attr.delete("locale")
      if locale
        switch_locale(locale) do
          send('tag:link_without_globalize', tag)
        end
      else
        send('tag:link_without_globalize', tag)
      end
    end

    tag 'locale' do |tag|
      I18n.locale.to_s
    end

    tag 'locales' do |tag|
      hash = tag.locals.locale = {}
      tag.expand
      raise TagError.new("'locales' tag must include a 'normal' tag") unless hash.has_key? :normal
    
      result = []
      codes = tag.attr["codes"].split("|").each do |code|
        hash[:code] = code
        if I18n.locale == code
          result << (hash[:active] || hash[:normal]).call
        else
          switch_locale(code) do
            result << hash[:normal].call
          end
        end
      end
      result.reject { |i| i.blank? }
    end
  
    [:normal, :active].each do |symbol|
      tag "locales:#{symbol}" do |tag|
        hash = tag.locals.locale
        hash[symbol] = tag.block
      end
    end
  
    tag 'locales:code' do |tag|
      hash = tag.locals.locale
      hash[:code]
    end
  
    tag 'with_locale' do |tag|
      code = tag.attr['code']
      raise TagError.new("'code' must be set") if code.blank?
      result = ''
      switch_locale(code) do
        result << tag.expand
      end
      result
    end

    tag 'if_translation_title' do |tag|
      page = tag.locals.page
      tag.expand if page.translated_locales.include?(I18n.locale.to_sym)
    end
  
    tag 'unless_translation_title' do |tag|
      page = tag.locals.page
      tag.expand unless page.translated_locales.include?(I18n.locale.to_sym)
    end
  
    tag 'if_translation_content' do |tag|
      name = tag.attr['part'] || 'body'
      part = tag.locals.page.part(name)
      tag.expand if part && part.translated_locales.include?(I18n.locale.to_sym)
    end
  
    tag 'unless_translation_content' do |tag|
      name = tag.attr['part'] || 'body'
      part = tag.locals.page.part(name)
      tag.expand if part.nil? || !part.translated_locales.include?(I18n.locale.to_sym)
    end
  
    private
      # Allows you to switch the current locale while within the block.
      # The previously current locale is reset after the block is finished.
      def switch_locale(locale)
        current_locale = I18n.locale
        I18n.locale = locale
        result = yield
        I18n.locale = current_locale
        result
      end
  end
end