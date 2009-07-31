require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  
  def valid_attributes
    {
      :title => "Kewl Page",
      :slug => "kewl-page",
      :breadcrumb => "Kewl Page"
    }
  end
  
  def create_page(options = {})
    page = Page.new
    page.attributes = valid_attributes.merge(options)
    page.save
    page
  end
  
  describe "validate unique_slug" do
    before(:each) do
      @parent = Factory.create(:page)
      @child = Factory.create(:child_page, :parent => @parent)
    end
    
    it "is valid" do
      page = create_page
      page.should be_valid
    end
    
    it "requires slug" do
      lambda do
        page = create_page(:slug => nil)
        page.errors.on(:slug).should_not be_nil
      end.should_not change(Page, :count)
    end
    
    it "requires slug to be unique" do
      
    end
  end
end