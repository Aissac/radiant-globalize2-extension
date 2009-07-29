module GlobalizeTags
  
  def self.included(base)
    base.class_eval do
      alias_method_chain :relative_url_for, :globalize
    end
  end
  
  def relative_url_for_with_globalize(*args)
    '/' + I18n.locale + relative_url_for_without_globalize(*args)
  end
  
end