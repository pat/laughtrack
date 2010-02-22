Given /^a show "([^\"]*)"$/ do |show|
  Show.make(
    :name => show
  )
end

Given /^a show "([^\"]*)" by "([^\"]*)"$/ do |show, act|
  act = Act.find_by_name(act) || Act.make(:name => act)
  Show.make(
    :name => show,
    :act  => act
  )
end

Given /^a show "([^\"]*)" by "([^\"]*)" with the keyword "([^\"]*)"$/ do |show, act, keyword|
  act  = Act.find_by_name(act) || Act.make(:name => act)
  show = Show.make(
    :name => show,
    :act  => act
  )
  show.keywords.delete_all
  show.keywords.create :words => keyword
end

Given /^"([^\"]*)" by "([^\"]*)" is (\d+)% sold out$/ do |show, act, percent|
  act = Act.find_by_name(act) || Act.make(:name => act)
  Show.make(
    :name             => show,
    :act              => act,
    :sold_out_percent => percent.to_f
  )
end

Given /^"([^\"]*)" by "([^\"]*)" has an average rating of (\d[\.\d]*)$/ do |show, act, rating|
  act = Act.find_by_name(act) || Act.make(:name => act)
  Show.make(
    :name   => show,
    :act    => act,
    :rating => rating.to_f
  )
end

Given /^a performance of "([^\"]*)"$/ do |show|
  Show.find_by_name(show).performances.make
end

Given /^a sold out performance of "([^\"]*)"$/ do |show|
  Show.find_by_name(show).performances.make :sold_out => true
end
