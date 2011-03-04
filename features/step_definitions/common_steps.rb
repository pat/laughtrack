When /^I select "([^"]*)" as the date and time$/ do |time|
  time = Time.parse(time)
  
  When %Q{I select "#{time.year}" from "Year"}
  When %Q{I select "#{time.strftime('%B')}" from "Month"}
  When %Q{I select "#{time.day}" from "Day"}
  When %Q{I select "#{time.strftime('%H')}" from "Hour"}
  When %Q{I select "#{time.strftime('%M')}" from "Minute"}
end
