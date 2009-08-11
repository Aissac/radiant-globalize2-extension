require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  
  before(:each) do
    I18n.locale = "en"
    home_page = Factory.create(:page, :title => "Home Page", :slug => "/", :status_id => 100)
    Factory.create(:page_part, :page => home_page, :content => "Home Page")
    
    level_one_child = Factory.create(:child_page, :title => "Level One Child", :parent => home_page)
    Factory.create(:page_part, :page => level_one_child, :content => "Level one child content")
    
    level_two_child = Factory.create(:child_page, :title => "Level Two Child", :parent => level_one_child)
    Factory.create(:page_part, :page => level_two_child, :content => "Level two child content")
  end
  
  it "should find and render home page for the current locale" do
    get :show_page, :url => '/'
    response.should be_success
    response.body.should == 'Home Page'
  end
  
  it "should find a page one level deep" do
    get :show_page, :url => 'level-one-child/'
    response.should be_success
    response.body.should == 'Level one child content'
  end
  
  it "should find a page two levels deep" do
    get :show_page, :url => 'level-one-child/level-two-child/'
    response.should be_success
    response.body.should == 'Level two child content'
  end
  
  it "should show page not found" do
    get :show_page, :url => 'a/non-existant/page'
    response.response_code.should == 404
    response.should render_template('site/not_found')
  end
end