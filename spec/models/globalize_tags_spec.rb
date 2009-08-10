require File.dirname(__FILE__) + '/../spec_helper'

describe "Globalize 2 Tags" do

  before do
    I18n.locale = "en"
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
        as("en ro")
    end
    
    it "prefers the between attribute when rendering the locales" do
      @page.
        should render("<r:locales codes='en|ro' between='|'><r:normal><r:locale /></r:normal><r:active><r:locale /></r:active></r:locales>").
        as("en|ro")      
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
        matching(/Cool Page \d*/)
    end
  end
  
  describe "<r:unless_translation_title />" do
    it "expands if the page's title is not translated" do
      not_translated_page = Factory.create(:page, :title => "Not Translated Page")
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
      not_translated_page = Factory.create(:page, :title => "Not Translated Page") 
      not_translated_page_part = Factory.create(:page_part, :page => not_translated_page, :content => "not-translated")
      switch_locale("ro") do
        not_translated_page.
          should render("<r:unless_translation_content part='body'><r:content /></r:unless_translation_content>").
          as("not-translated")
      end
    end
  end
  
  describe "<r:link_with_globalize />" do
    it "renders the link with the current locale if 'locale' tag attribute is not set" do
      @page.should render("<r:link />").matching(/<a href=\"\/en\/cool-page-\d*\/\">Cool Page \d*\<\/a>/)
    end
    
    it "renders the link with the given locale if the 'locale' tag attribute is set" do
      @page.should render("<r:link locale='ro' />").as("<a href=\"/ro/pagina-cool/\">Pagina Cool</a>")
    end
  end
  
  describe "<r:children:each />" do
    before(:each) do
      @parent = Factory.create(:page)
      child_one = Factory.create(:child_page, :parent => @parent)
      Factory.create(:child_page, :parent => @parent)

      Factory.create(:romanian_page_translation, :page => child_one, :title => "Pagina 1")
    end
    
    it "filters the children by locale if 'locale' attribute is not set to false" do
      switch_locale("ro") do
        @parent.
          should render("<r:children:each><r:title /> </r:children:each>").
          as("Pagina 1 ")
      end
    end
    
    it "does not filter by locale if 'locale' attribute is set to false" do
      switch_locale("ro") do
        @parent.
          should render("<r:children:each locale='false'><r:title /> </r:children:each>").
          matching(/Pagina 1 Child page \d*/)
      end
    end
  end
  
  describe "<r:paginate_with_globalize />" do
    before(:each) do
      @parent = Factory.create(:page)
      child_one = Factory.create(:child_page, :parent => @parent)
      Factory.create(:romanian_page_translation, :page => child_one, :title => "Pagina 1")
      (1..4).map{ |i| Factory.create(:child_page, :parent => @parent) }
    end
    
    it "filters the paginated children by locale if 'locale' tag attribute is not set to false" do
      switch_locale("ro") do
        @parent.
          should render("<r:paginate per_page='2'><r:each><r:title /></r:each></r:paginate>").
          as("Pagina 1")
      end
    end
    
    it "does not filter paginated children by locale if 'locale' tag attribute is set to false" do
      switch_locale("ro") do
        @parent.
          should render("<r:paginate per_page='2' locale='false'><r:each><r:title /> </r:each></r:paginate>").
          matching(%r{Pagina 1 Child page \d*})
      end
    end
  end
end