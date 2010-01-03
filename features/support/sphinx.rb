require 'cucumber/thinking_sphinx/external_world'

Cucumber::ThinkingSphinx::ExternalWorld.new

Before('@no-txn') do
  Given 'a clean slate'
end

After('@no-txn') do
  Given 'a clean slate'
end
