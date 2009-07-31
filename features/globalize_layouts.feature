Feature: Globalize 2
  In order to take advantage of the many languages I speak
  As an admin
  I want to be able to globalize my layouts
  
  Background:
    Given I am logged in as an admin

  Scenario: Translating a layout
    Given a layout "Cool Layout" exists
      And I am on the layouts index page
      And I follow "Cool Layout"
      And I follow "RO"
      And I fill in "layout_content" with "continut romanesc"
      And I press "Save Changes"
     Then the "Cool Layout" layout should be saved for "ro" locale
      And the "Cool Layout" layout should contain "continut romanesc" for "ro" locale
      And the "Cool Layout" layout should be saved for "en" locale
      And the "Cool Layout" layout should contain "english content" for "en" locale