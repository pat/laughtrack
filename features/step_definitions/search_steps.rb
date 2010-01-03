Given /^a clean slate$/ do
  Object.subclasses_of(ActiveRecord::Base).each do |model|
    model.connection.execute "TRUNCATE TABLE #{model.table_name}"
  end
end

Given /^the (\w+) indexes are processed$/ do |model|
  model = model.titleize.constantize
  ThinkingSphinx::Test.index *model.sphinx_index_names
end
