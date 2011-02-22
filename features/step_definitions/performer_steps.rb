Given /^a performer "([^\"]*)"$/ do |name|
  Performer.make! :name => name
end
