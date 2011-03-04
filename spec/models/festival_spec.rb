require 'spec_helper'

describe Festival do
  describe '#valid?' do
    it_requires_a :name
    it_requires_a :year
    it_requires_a :starts_on
    it_requires_a :ends_on
  end
end
