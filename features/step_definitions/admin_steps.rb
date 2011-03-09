Given /^an admin "([^"]*)"$/ do |email|
  Admin.make! :email => email
end

Given /^I am logged in as admin "([^"]*)"$/ do |email|
  When  %Q{I go to the admin login page}
  And   %Q{I follow "Sign Out"} if page.has_content?("Sign Out")
  And   %Q{I fill in "Email" with "#{email}"}
  And   %Q{I fill in "Password" with "password"}
  And   %Q{I press "Sign in"}
end
