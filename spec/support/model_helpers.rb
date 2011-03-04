module ModelHelpers
  def self.included(base)
    base.instance_eval do
      extend ModelHelpers::ClassMethods
    end
  end
  
  module ClassMethods
    def it_requires_a(attribute)
      it "requires a #{attribute}" do
        instance = self.class.describes.make attribute => nil
        instance.should have(1).error_on(attribute)
      end
    end
    
    def it_requires_an(attribute)
      it "requires an #{attribute}" do
        instance = self.class.describes.make attribute => nil
        instance.should have(1).error_on(attribute)
      end
    end
  end
end

RSpec.configure do |config|
  config.include ModelHelpers, :type => :model
end
