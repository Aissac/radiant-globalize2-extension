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
    
    tag 'children:each_with_globalize' do |tag|
      with_translated_locales = tag.attr['locale'] == 'false' ? false : true
      if with_translated_locales
        result = Page.scope_locale(I18n.locale) do
          send('tag:children:each_without_globalize', tag)
        end
      else
        result = send('tag:children:each_without_globalize', tag)
      end
      result
    end

    desc %{
      Renders the current locale.
      
      *Usage:*
      
      <pre><code><r:locale /></code></pre>
    }
    tag 'locale' do |tag|
      I18n.locale.to_s
    end
    
    desc %{      
      Renders the locales passed in @codes@ attribute. Use the @between@ attribute to specify something between the rendered locale codes.
      
      *Example*
      
<pre><code>
<ul>
  <r:locales codes='en|ro'>
    <r:normal>
      <li><r:link id='<r:locale />'><r:locale /></r:link></li>
    </r:normal>
    <r:active>
      <li><r:link id='<r:locale />'><r:locale /></r:link></li>
    </r:active>
  </r:locales>        
</ul>
</code></pre>
    }
    tag 'locales' do |tag|
      hash = tag.locals.locale = {}
      tag.expand
      raise TagError.new("'locales' tag must include a 'normal' tag") unless hash.has_key? :normal
      raise TagError.new("'codes' attribute must be set") if tag.attr['codes'].blank?
      
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
      between = tag.attr["between"] || " "
      result.reject { |i| i.blank? }.join(between)
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
  
    desc %{
      Temporarily switch the locale within the block. Use the @code@ attribute so specify the locale you want to switch to.
      
      *Usage:* 
      
      <pre><code><r:with_locale code='en'>...</r:with_locale></code></pre>
    }
    tag 'with_locale' do |tag|
      code = tag.attr['code']
      raise TagError.new("'code' must be set") if code.blank?
      result = ''
      switch_locale(code) do
        result << tag.expand
      end
      result
    end

    desc %{
      Renders the containing elements if the page's title is translated. This doesn't necessarily mean the content (page parts) are translated.
      
      *Usage:*
      
      <pre><code><r:if_translation_title>...</r:if_translation_title></code></pre>
    }
    tag 'if_translation_title' do |tag|
      page = tag.locals.page
      tag.expand if page.translated_locales.include?(I18n.locale.to_sym)
    end
  
    desc %{
      The opposite of the @if_translation_title@ tag. Renders the containing elements if the page's title is not translated.
      
      *Usage:*
      
      <pre><code><r:unless_translation_title>...</r:unless_translation_title></code></pre>
    }
    tag 'unless_translation_title' do |tag|
      page = tag.locals.page
      tag.expand unless page.translated_locales.include?(I18n.locale.to_sym)
    end
  
    desc %{
      Renders the containing elements if the page's part is translated. By default the @part@ attribute is set to @body@
      
      *Usage:*
      
      <pre><code><r:if_translation_content [part='part_name']>...</r:if_translation_content></code></pre>
      
    }
    tag 'if_translation_content' do |tag|
      name = tag.attr['part'] || 'body'
      part = tag.locals.page.part(name)
      tag.expand if part && part.translated_locales.include?(I18n.locale.to_sym)
    end
  
    desc %{
      The opposite of the @if_translation_content@ tag. Renders the containing elements if the page's part is not translated. By default, the @part@ attribute is set to @body@
      
      *Usage:*
      
      <pre><code><r:unless_translation_content [part='part_name']>...</r:unless_translation_content></code></pre>
    }
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