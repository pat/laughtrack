Given /^a festival "([^"]*)" in (\d+)$/ do |name, year|
  Festival.make! :name => name, :year => year.to_i
end