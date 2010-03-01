require 'faker'

Sham.email { |index| "user#{index}@example.com" }

Act.blueprint do
  # Act#make is overwritten. See below.
end

Keyword.blueprint do
  show  { Show.make }
  words { 'foo bar' }
end

Performance.blueprint do
  show       { Show.make }
  happens_at { Time.now  }
  sold_out   { false     }
end

Performer.blueprint do
  name    { Faker::Name.name }
  country 'Australia'
end

Show.blueprint do
  name { Faker::Name.name }
  act  { Act.make({}) }
end

User.blueprint do
  email
  password              { "password" }
  password_confirmation { "password" }
end

User.blueprint(:confirmed) do
  email_confirmed { true }
end

User.blueprint(:admin) do
  email_confirmed { true }
  admin           { true }
end

module ActBlueprint
  def make(attributes = {})
    act = make_unsaved attributes
    act.save!
    act
  end
  
  def make_unsaved(attributes = {})
    act             = Act.new(attributes)
    
    unless attributes.has_key?(:name)
      act.name        = Faker::Name.name
      unless attributes.has_key?(:performers)
        act.performers  = [Performer.make(:name => act.name)]
      end
    end
    
    act
  end
end

Act.extend ActBlueprint
