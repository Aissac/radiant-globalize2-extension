# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class Globalize2Extension < Radiant::Extension
  version "0.1"
  description "Translate content in Radiant CMS using the Globalize2 Rails plugin."
  url "http://blog.aissac.ro/radiant/globalize2-extension/"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :globalize2
  #   end
  # end
  
  GLOBALIZABLE_CONTENT = {
    Page     => [:title, :slug, :breadcrumb, :description, :keywords],
    PagePart => [:content],
    Layout   => [:content],
    Snippet  => [:content]
  }
  
  def activate
    GLOBALIZABLE_CONTENT.each do |model, columns|
      model.send(:translates, *columns)
    end
    # admin.tabs.add "Globalize2", "/admin/globalize2", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Globalize2"
  end
  
end
