Feature: Globalize 2
  In order to take advantage of the many languages I speak
  As an admin
  I want to be able to globalize my pages

  Background:
    Given I am logged in as an admin

  Scenario: Changing locale
    Given a page "Cool Page" exists translated to "Pagina cool"
      And I am on the pages index page
     When I follow "RO"
     Then I should see "Pagina cool"
     When I follow "EN"
     Then I should see "Cool Page"
     
  Scenario: Translating a page
    Given a page "Cool Page" exists
      And I am on the pages index page
     When I follow "Cool Page"
      And I follow "RO"
      And I fill in "Page Title" with "Pagina cool"
      And I press "Save Changes"
     Then I should be on the pages index page
      And I should see "Pagina cool"
     When I follow "EN"
     Then I should see "Cool Page"
  
  Scenario: Translating content for a page
    Given a page "Cool Page" exists with a "body" page part
      And I am on the pages index page
     When I follow "Cool Page"
      And I follow "RO"
      And I fill in "part_body_content" with "continut romanesc"
      And I press "Save Changes"
     Then the "Cool Page" page should contain "continut romanesc" for "ro" locale
      And the "Cool Page" page should contain "english content" for "en" locale

  Scenario: Deleting a translation
    Given a page "Cool Page" exists translated to "Pagina cool"
      And I am on the pages index page
     When I follow "Cool Page"
      And I follow "RO"
      And I check "Delete RO translation"
      And I press "Save Changes"
     Then I should be on the pages index page
      And I should not see "Pagina cool"
     When I follow "EN"
     Then I should see "Cool Page"
     
  Scenario: The locale is changed to default when creating a new page
    Given a page "HomePage" exists
      And I am on the pages index page
      And I follow "RO"
     When I follow "add child"
     Then I should see "The locale has been changed to default."
      And I should see "(default)"
      