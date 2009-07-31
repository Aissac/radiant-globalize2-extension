Feature: Globalize 2
  In order to take advantage of the many languages I speak
  As an admin
  I want to be able to globalize my snippet
  
  Background:
    Given I am logged in as an admin

  Scenario: Translating a layout
    Given a snippet "Cool_Snippet" exists
      And I am on the snippets index page
      And I follow "Cool_Snippet"
      And I follow "RO"
      And I fill in "snippet_content" with "continut romanesc"
      And I press "Save Changes"
     Then the "Cool_Snippet" snippet should be saved for "ro" locale
      And the "Cool_Snippet" snippet should contain "continut romanesc" for "ro" locale
      And the "Cool_Snippet" snippet should be saved for "en" locale
      And the "Cool_Snippet" snippet should contain "english content" for "en" locale