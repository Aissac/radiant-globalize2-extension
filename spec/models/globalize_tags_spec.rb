require File.dirname(__FILE__) + '/../spec_helper'

describe "Globalize 2 Tags" do
  
  before do
    @page = Factory.create(:page)
    Factory.create(:romanian_page_translation, :page => @page)
    @page_part = Factory.create(:page_part, :page => @page)
    Factory.create(:romanian_page_part_translation, :page_part => @page_part)
  end
  
  describe "<r:locale />" do
    it "returns the current locale" do
      @page.should render("<r:locale />").as("en")
    end
  end
  
  describe "<r:locales />" do
    it "raises an error if <r:normal /> tag is not included" do
      @page.
        should render("<r:locales codes='en|ro'><r:locale /></r:locales>").
        with_error("'locales' tag must include a 'normal' tag")
    end
    
    it "renders the list of codes supplied" do
      @page.
        should render("<r:locales codes='en|ro'><r:normal><r:locale /></r:normal><r:active><r:locale /></r:active></r:locales>").
        as("enro")
    end
  end
  
  describe "<r:with_locale />" do
    it "raises error if 'code' tag attribute is not set" do
      @page.
        should render("<r:with_locale />").
        with_error("'code' must be set")
    end
    
    it "switches the locale" do
      @page.
        should render("<r:with_locale code='ro'><r:link /></r:with_locale>").
        as("<a href=\"/ro/pagina-cool/\">Pagina Cool</a>")
    end
  end
  
  describe "<r:if_translation_title />" do
    it "expands if the page's title is translated" do
      @page.
        should render("<r:if_translation_title><r:title /></r:if_translation_title>").
        as("Cool Page")
    end
  end
  
  describe "<r:unless_translation_title />" do
    it "expands if the page's title is not translated" do
      not_translated_page = Factory.create(:not_translated_page)
      switch_locale("ro") do
        not_translated_page.
          should render("<r:unless_translation_title><r:title /></r:unless_translation_title>").
          as("Not Translated Page")
      end
    end
  end
  
  describe "<r:if_translation_content />" do
    it "expands if the page's 'body' part is translated" do
      @page.
        should render("<r:if_translation_content part='body'><r:content /></r:if_translation_content>").
        as("english content")
    end
  end
  
  describe "<r:unless_translation_content" do
    it "expands if the page's 'body' part is not translated" do
      not_translated_page = Factory.create(:not_translated_page) 
      not_translated_page_part = Factory.create(:not_translated_page_part, :page => not_translated_page)
      switch_locale("ro") do
        not_translated_page.
          should render("<r:unless_translation_content part='body'><r:content /></r:unless_translation_content>").
          as("not-translated")
      end
    end
  end
end