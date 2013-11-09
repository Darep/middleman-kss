Feature: Middleman KSS configuration

  Scenario: Styleblock path is configurable
    Given the Server is running at "test-config-app"
    When I go to "/styleguide.html"
    Then I should see '<button class="btn">Button</button>'
