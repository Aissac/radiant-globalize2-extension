# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class Globalize2Extension < Radiant::Extension
  version "1.0"
  description "Translate content in Radiant CMS using the Globalize2 Rails plugin."
  url "http://blog.aissac.ro/radiant/globalize2-extension/"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :globalize2
  #   end
  # end
  
  def activate
    # admin.tabs.add "Globalize2", "/admin/globalize2", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Globalize2"
  end
  
end
