require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PagesController do
  dataset :users
  
  before(:each) do
    login_as :developer
    
    I18n.default_locale = "en"
    @home_page = Factory.create(:page, :title => "Home Page", :slug => "/")
  end
  
  it "should reset the locale to default" do
    switch_locale("ro") do
      get :new, :page_id => @home_page.id
      response.should be_success
      session[:locale].should == "en"
      I18n.locale.should == "en"
    end
  end
  
end