Feature: Organization's profile
  In order to acquire info about an organization
  As a visitor/person
  I want to see an organization's profile

  Background:
    Given an organization named "Brewhouse"

  Scenario: View public profile
    When I visit the profile page
    Then I should see the organization's profile

  Scenario: View organization's address
    When I visit the profile page
    Then I should see the organization's address

  Scenario: User claims organization's profile
    When I visit the profile page
    And I claim the profile
    And I login with "Twitter"
    Then I should be the organization's admin user
    And I should see the organization on my profile

  Scenario: Admin user adds arbitary links to profile
    When I visit the profile page
    And I add a profile link for "brewhouse.io"
    Then I should see the "brewhouse.io" link on the profile