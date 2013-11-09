Feature: Styleblock rendering

  Scenario: Renders plain styleblock
    Given the Server is running at "test-app"
    When I go to "/elements.html"
    Then I should see '<button class="btn">Button</button>'

  Scenario: Renders the styleguide
    Given the Server is running at "test-app"
    When I go to "/styleguide.html"
    Then I should see '<h1>Styleguide</h1>'

  Scenario: Renders pseudo classes when section is found
    Given the Server is running at "test-app"
    When I go to "/styleguide.html"
    Then I should see '<button class="btn pseudo-class-hover">Button</button>'

  Scenario: Support for Middleman's 'partial' helper
    Given the Server is running at "test-app"
    When I go to "/styleguide.html"
    Then I should see '<a href="#" class="btn pseudo-class-hover">Link button</a>'

  Scenario: Display an error for non-existing section
    Given the Server is running at "test-app"
    Then going to "/invalid-section.html" should raise an exception with message "Section must have a description."
