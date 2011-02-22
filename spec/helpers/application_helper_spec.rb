require 'spec_helper'

describe ApplicationHelper do
  describe '#link_to_show' do
    it "should return a link with the show's name" do
      show = Show.make!
      helper.link_to_show(show).should == helper.link_to(show.name, show)
    end
    
    it "should handle show ids" do
      show = Show.make!
      helper.link_to_show(show.id).should == helper.link_to(show.name, show)
    end
  end
  
  describe '#act_name' do
    it "should return an empty string if the act is nil" do
      helper.act_name(nil).should == ''
    end
    
    it "should return the act's name by default" do
      act = Act.make!
      helper.act_name(act).should == act.name
    end
  end
  
  describe '#performance_sold_out_link' do
    it "should link to the sold out page if the performance isn't sold out" do
      performance = Performance.make!(:sold_out => false)
      helper.performance_sold_out_link(performance).
        should == helper.link_to(
          'Sold Out', [:sold_out, :admin, performance.show, performance]
        )
    end
    
    it "should link to the available page if the performance is sold out" do
      performance = Performance.make!(:sold_out => true)
      helper.performance_sold_out_link(performance).
        should == helper.link_to(
          'Not Sold Out', [:available, :admin, performance.show, performance]
        )
    end
  end
end
