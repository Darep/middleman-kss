Feature: Middleman KSS configuration

  Scenario: Styleblock path is configurable
    Given the Server is running at "test-config-app"
    When I go to "/styleguide.html"
    Then I should see '<button class="btn">Button</button>'

  Scenario: Can use a custom styleguide block file
    Given the Server is running at "test-config-app"
    When I go to "/styleguide.html"
    Then I should see '<div class="styleguide-test"><button class="btn">Button</button>'

  Scenario: Styleguide block file is configurable
    Given the Server is running at "test-config-app"
    When I go to "/styleguide.html"
    Then I should see '<div class="styleguide-test"><button class="btn">Button</button>'
