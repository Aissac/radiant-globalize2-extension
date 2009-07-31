# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../../config/environment')
 
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
require 'webrat'
 
Webrat.configure do |config|
  config.mode = :rails
end

Before do
  ActiveRecord::Base.connection.tables.each do |table|
    begin
      table.classify.constantize.delete_all
    rescue StandardError => e
      # silent
    end
  end
  Radiant::Config.create!(:key => 'globalize.languages', :value => "ro") if Radiant::Config['globalize.languages'].blank?
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

gem 'thoughtbot-factory_girl', '>= 1.2.1'
require 'factory_girl'

require File.dirname(__FILE__) + "/../../spec/factories.rb"