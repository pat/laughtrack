Given /^a clean slate$/ do
  DatabaseCleaner.clean
end

Given /^the (\w+) indexes are processed$/ do |model|
  model = model.titleize.constantize
  ThinkingSphinx::Test.index *model.sphinx_index_names
end
