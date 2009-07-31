Given /^I am logged in as an admin$/ do
  User.create!(:login => 'admin', :password => 'secret', :password_confirmation => 'secret', :name => 'Administrator')
  Given "I go to to \"the welcome page\""
  When "I fill in \"Username\" with \"admin\""
  When "I fill in \"Password\" with \"secret\""
  When "I press \"Login\""
end

Given /^a page "([^\"]*)" exists$/ do |title|
  Factory.create(:page, :title => title)
end

Given /^a page "([^\"]*)" exists translated to "([^\"]*)"$/ do |title, translated_title|
  page = Factory.create(:page, :title => title)
  Factory.create(:romanian_page_translation, :page => page, :title => translated_title)
end