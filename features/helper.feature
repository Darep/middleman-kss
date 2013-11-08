Feature: Syntax highlighting with the "code" helper method

  Scenario: Works from ERb
    Given the Server is running at "test-app"
    When I go to "/styleguide.html"
    Then I should see '<h1>Styleguide</h1>'
    Then I should see '<pre class="highlight plaintext">This is some code'
