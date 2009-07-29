# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class Globalize2Extension < Radiant::Extension
  version "0.1"
  description "Translate content in Radiant CMS using the Globalize2 Rails plugin."
  url "http://blog.aissac.ro/radiant/globalize2-extension/"
  
  raise "You must define GLOBALIZE_BASE_LANGUAGE in your environment.rb" unless defined?(GLOBALIZE_BASE_LANGUAGE)
  raise "You must define GLOBALIZE_LANGUAGES in your environment.rb" unless defined?(GLOBALIZE_LANGUAGES)  
  
  define_routes do |map|
    map.connect '/:locale/*url', :controller => 'site', :action => 'show_page',
      :locale => Regexp.compile(locales.join("|"))
  end
  
  GLOBALIZABLE_CONTENT = {
    Page     => [:title, :slug, :breadcrumb, :description, :keywords],
    PagePart => [:content],
    Layout   => [:content],
    Snippet  => [:content]
  }
  
  def self.locales
    @@locales ||= [GLOBALIZE_BASE_LANGUAGE, *GLOBALIZE_LANGUAGES].map(&:to_s)
  end
  
  def activate
    admin.page.edit.add :form, 'admin/shared/change_locale', :before => 'edit_page_parts'
    admin.snippet.edit.add :form, 'admin/shared/change_locale', :before => 'edit_content'
    admin.layout.edit.add :form, 'admin/shared/change_locale', :before => 'edit_content'
    
    admin.page.index.add :top, 'admin/shared/change_locale_admin'
    admin.layout.index.add :top, 'admin/shared/change_locale_admin'
    admin.snippet.index.add :top, 'admin/shared/change_locale_admin'
    
    admin.page.index.add :sitemap_head, 'admin/shared/globalize_th'
    admin.page.index.add :node, 'admin/shared/globalize_td'
    
    I18n.default_locale = GLOBALIZE_BASE_LANGUAGE
    
    Page.class_eval {
      include GlobalizeTags
      include Globalize2::PageExtensions
    }
    ApplicationController.send(:include, Globalize2::ApplicationControllerExtensions)
    
    GLOBALIZABLE_CONTENT.each do |model, columns|
      model.send(:translates, *columns)
    end
  end
  
  def deactivate
  end
  
end
