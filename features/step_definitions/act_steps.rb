Given /^"([^\"]*)" is part of "([^\"]*)"$/ do |performer, act|
  performer = Performer.find_or_create_by_name(performer)
  act       = Act.find_by_name(act)
  
  act.performers << performer
  act.save
end
