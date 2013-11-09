require "rack/test"

Then /^going to "([^\"]*)" should raise an exception with message "(.*)"$/ do |url, message|
  lambda { @browser.get(URI.escape(url)) }.should raise_exception(Exception, /#{Regexp.escape message}/)
end
