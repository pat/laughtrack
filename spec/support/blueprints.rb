require 'machinist/active_record'

Machinist.configure do |config|
  config.cache_objects = false
end

Act.blueprint do
  # Act#make is overwritten. See below.
  name { "Act #{serial_number}" }
end

Keyword.blueprint do
  show
  words { 'foo bar' }
end

Performance.blueprint do
  show
  happens_at { Time.now  }
  sold_out   { false     }
end

Performer.blueprint do
  name    { "Performer #{serial_number}" }
  country { 'Australia' }
end

Show.blueprint do
  name { "Show #{serial_number}" }
  act
end

ShowHistory.blueprint do
  show                  { Show.make! }
  sold_out_percent      { 0.0 }
  rating                { 0.0 }
  confirmed_tweet_count { 9 }
  positive_tweet_count  { 8 }
  day                   { Date.new(2010, 04, 01) }
end

User.blueprint do
  email                 { "user#{serial_number}@example.com" }
  password              { "password" }
  password_confirmation { object.password }
end

User.blueprint(:confirmed) do
  confirmed_at { object.skip_confirmation!; 1.day.ago }
end

User.blueprint(:admin) do
  confirmed_at { object.skip_confirmation!; 1.day.ago }
  admin        { true }
end

module ActBlueprint
  def make(attributes = {})
    act = super
    
    unless attributes.has_key?(:performers) || act.name.blank?
      act.performers = [Performer.make!(:name => act.name)]
    end
    
    act
  end
end

Act.extend ActBlueprint
