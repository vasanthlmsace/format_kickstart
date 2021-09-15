@format @format_kickstart @_file_upload

Feature: Check the kickstart course format features.
   Background: Create users to check the visbility.
    Given the following "users" exist:
      | username | firstname | lastname | email              |
      | coursecreator1 | Coursecreator   | user1   | coursecreator1@test.com  |
      | coursecreator2 | Coursecreator   | User2   | coursecreator2@test.com  |
    And the following "courses" exist:
      | fullname | shortname | category | enablecompletion | showcompletionconditions |
      | Course 1 | C1        | 0        | 1                | 1                        |
      | Course 2 | C2        | 0        | 1                | 1                        |
    And the following "categories" exist:
      | name | category | idnumber |
      | Cat 1 | 0 | CAT1 |
      | Cat 2 | 0 | CAT2 |
    And the following "role assigns" exist:
      | user    | role          | contextlevel | reference |
      | coursecreator1 | coursecreator       | Category     | CAT1      |
      | coursecreator1 | coursecreator       | Category     | CAT2      |


  @javascript @_cross_browser
  Scenario: Check the template actions.
    # Admin view.
    Given I log in as "admin"
    And I create a kickstart template with:
      | Title | Test template 1 |
    Then I should see "Template successfully created"
    Then I should see "Test template 1" in the "#templates_r0" "css_element"
    And I click on "#templates_r0_c4 .singlebutton:nth-child(1)" "css_element" in the "Test template 1" "table_row"
    And I set the following fields to these values:
      | Title | Demo template 1|
    And I press "Save changes"
    And I should see "Template successfully edited"
    Then I should see "Demo template 1" in the "#templates_r0" "css_element"
    And I click on "#templates_r0_c4 .singlebutton:nth-child(2)" "css_element" in the "Demo template 1" "table_row"
    #Then the field "Title" matches value "Demo template 1"
    And I press "Delete"
    And I should see "Template successfully deleted"
    And I log out

  @javascript
  Scenario: Check the import template.
      Given I log in as "admin"
      And I navigate to "Plugins > Course formats > Manage templates" in site administration
      And I press "Create template"
      And I set the following fields to these values:
        | Title | Test template 1|
      And I upload "/course/format/kickstart/tests/course-10-online.mbz" file to "Course backup file (.mbz)" filemanager
      And I press "Save changes"
      And I should see "Template successfully created"
      And I press "Create template"
      And I set the following fields to these values:
        | Title | Test template 2|
      And I upload "/course/format/kickstart/tests/course.mbz" file to "Course backup file (.mbz)" filemanager
      And I press "Save changes"
      And I should see "Template successfully created"
      And I set kickstart format setting with:
        | Course creator redirect | 1 |
      And I log out
      Then I log in as "coursecreator1"
      And I am on course index
      And I follow "Cat 1"
      Then I should see "Add a new course"
      And I press "Add a new course"
      And I set the following fields to these values:
        | Course full name | Test course 1|
        | Course category | Cat 1 |
      And I press "Continue"
      Then I should see "Proceed to course content"
      And I should see "Teacher, Course creator" in the "Coursecreator user1" "table_row"
      And I press "Proceed to course content"
      Then I should see "Welcome to your new course" in the ".course-content h3" "css_element"
      And I click on "Use template" "link" in the ".card-footer" "css_element"
      And I click on "Import" "button"
      And I start watching to see if a new page loads
      And I follow "Test course 1"
      Then I should see "Introduction"
