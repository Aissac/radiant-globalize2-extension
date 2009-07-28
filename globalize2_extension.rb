# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class Globalize2Extension < Radiant::Extension
  version "0.1"
  description "Translate content in Radiant CMS using the Globalize2 Rails plugin."
  url "http://blog.aissac.ro/radiant/globalize2-extension/"
  
  # define_routes do |map|
  #   map.connect '/:locale/*url', :controller => 'site', :action => 'show_page',
  #     :locale => Regexp.compile(locales.join("|"))
  # end
  
  GLOBALIZABLE_CONTENT = {
    Page     => [:title, :slug, :breadcrumb, :description, :keywords],
    PagePart => [:content],
    Layout   => [:content],
    Snippet  => [:content]
  }
  
  # def self.locales
  #   @@locales ||= [GLOBALIZE_BASE_LANGUAGE, *GLOBALIZE_LANGUAGES].map(&:to_s)
  # end
  
  def activate
    Page.send(:include, Globalize2::PageExtensions)
    
    GLOBALIZABLE_CONTENT.each do |model, columns|
      model.send(:translates, *columns)
    end
  end
  
  def deactivate
  end
  
end
