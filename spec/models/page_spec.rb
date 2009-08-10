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
      @child = Factory.create(:page, :parent => @parent, :title => "Child Page")
      @another = Factory.create(:page, :parent => @parent)
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
    
    it "does not require slug to be unique outside the scope of parent" do
      lambda do
        page = create_page(:parent => @another, :slug => "child-page")
        page.errors.on(:slug).should be_nil
      end.should change(Page, :count).by(1)
    end
    
    it "does not require slug to be unique outsiez the scope of locale" do
      switch_locale("ro") do
        lambda do
          page = create_page(:parent => @parent, :slug => "child-page")
          page.errors.on(:slug).should be_nil
        end.should change(Page, :count)
      end
    end
    
    it "requires slug to be unique within the scope of parent and locale" do
      lambda do
        page = create_page(:parent => @parent, :slug => "child-page")
        page.errors.on(:slug).should == "must be unique"
      end.should_not change(Page, :count)
    end
  end
  
  describe "reset translation" do
    before(:each) do
      @page = Factory.create(:page)
      Factory.create(:romanian_page_translation, :page => @page)
      @page_part = Factory.create(:page_part, :page => @page)
      Factory.create(:romanian_page_part_translation, :page_part => @page_part)
      @page.reset_translations = true
    end
    
    it "deletes the translation for a locale if reset_translations is set to true" do
      switch_locale("ro") do
        @page.save
        @page.translated_locales.should_not include("ro")
      end
    end
    
    it "deletes the page part translation for a locale if reset_translations is set to true" do
      switch_locale("ro") do
        @page.save
        @page.parts.first.translated_locales.should_not include("ro")
      end
    end
  end
end