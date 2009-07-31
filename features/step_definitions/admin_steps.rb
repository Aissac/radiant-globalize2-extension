Given /^I am logged in as an admin$/ do
  User.create!(:login => 'admin',
    :password => 'secret',
    :password_confirmation => 'secret',
    :name => 'Administrator',
    :admin => true)
  Given "I go to to \"the welcome page\""
  When "I fill in \"Username\" with \"admin\""
  When "I fill in \"Password\" with \"secret\""
  When "I press \"Login\""
end

Given /^a page "([^\"]*)" exists$/ do |title|
  Factory.create(:page, :title => title)
end

Given /^a page "([^\"]*)" exists with a "([^\"]*)" page part$/ do |title, part|
  page = Factory.create(:page, :title => title)
  Factory.create(:page_part, :name => part, :page => page)
end

Given /^a page "([^\"]*)" exists translated to "([^\"]*)"$/ do |title, translated_title|
  page = Factory.create(:page, :title => title)
  Factory.create(:romanian_page_translation, :page => page, :title => translated_title)
end

Then /^the "([^\"]*)" page should contain "([^\"]*)" for "([^\"]*)" locale$/ do |title, content, locale|
  page = Page.find_by_title(title)
  page.parts.first.globalize_translations.find_by_locale(locale).content.should == content
end

Given /^a layout "([^\"]*)" exists$/ do |name|
  Factory.create(:layout, :name => name)
end

Then /^the "([^\"]*)" layout should be saved for "([^\"]*)" locale$/ do |name, locale|
  layout = Layout.find_by_name(name)
  layout.translated_locales.should include(locale.to_sym)
end

Then /^the "([^\"]*)" layout should contain "([^\"]*)" for "([^\"]*)" locale$/ do |name, content, locale|
  layout = Layout.find_by_name(name)
  layout.globalize_translations.find_by_locale(locale).content.should == content
end

Given /^a snippet "([^\"]*)" exists$/ do |name|
  Factory.create(:snippet, :name => name)
end

Then /^the "([^\"]*)" snippet should be saved for "([^\"]*)" locale$/ do |name, locale|
  snippet = Snippet.find_by_name(name)
  snippet.translated_locales.should include(locale.to_sym)
end

Then /^the "([^\"]*)" snippet should contain "([^\"]*)" for "([^\"]*)" locale$/ do |name, content, locale|
  snippet = Snippet.find_by_name(name)
  snippet.globalize_translations.find_by_locale(locale).content.should == content
end