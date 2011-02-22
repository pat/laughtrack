require 'spec_helper'

describe LaughTrack::TimeParser do
  describe '#times' do
    it "should handle one time" do
      LaughTrack::TimeParser.new("Mon-Thu 7.30pm").times.should == ["7.30pm"]
    end
    
    it "should handle two times" do
      LaughTrack::TimeParser.new("2pm & 5pm").times.should == ["2pm", "5pm"]
    end
    
    it "should handle three times" do
      LaughTrack::TimeParser.new("Fri-Sat 9pm, Sun 6pm & Mon-Tue 7pm").times.
        should == ["9pm", "6pm", "7pm"]
    end
  end
  
  describe '#time_parts' do
    it "should strip out ampersands" do
      LaughTrack::TimeParser.new("2pm & 5pm").time_parts.
        should == ["2pm", "5pm"]
    end
    
    it "should strip out commas" do
      LaughTrack::TimeParser.new("Fri-Sat 9pm, Sun 6pm & Mon-Tue 7pm").
        time_parts.should == ["Fri-Sat 9pm", "Sun 6pm", "Mon-Tue 7pm"]
    end
  end
  
  describe '#performances_for_day' do
    it "should handle times on the hour" do
      parser = LaughTrack::TimeParser.new "10pm"
      parser.performances_for_day(Date.new(2010, 3, 30)).should == [
        Time.local(2010, 3, 30, 22, 0)
      ]
    end
    
    it "should handle times with minutes" do
      parser = LaughTrack::TimeParser.new "7.30pm"
      parser.performances_for_day(Date.new(2010, 3, 30)).should == [
        Time.local(2010, 3, 30, 19, 30)
      ]
    end
    
    it "should handle morning times" do
      parser = LaughTrack::TimeParser.new "11.30am"
      parser.performances_for_day(Date.new(2010, 3, 30)).should == [
        Time.local(2010, 3, 30, 11, 30)
      ]
    end
    
    it "should understand days in time parts" do
      parser = LaughTrack::TimeParser.new "Fri-Sat 9pm, Sun 6pm & Mon-Tue 7pm"
      
      # Friday
      parser.performances_for_day(Date.new(2010, 4, 2)).should == [
        Time.local(2010, 4, 2, 21, 0)
      ]
      
      # Sunday
      parser.performances_for_day(Date.new(2010, 4, 4)).should == [
        Time.local(2010, 4, 4, 18, 0)
      ]
      
      # Tuesday
      parser.performances_for_day(Date.new(2010, 4, 6)).should == [
        Time.local(2010, 4, 6, 19, 0)
      ]
    end
    
    it "should handle multiple days with ampersand" do
      parser = LaughTrack::TimeParser.new "Thu-Sat 8pm, Wed & Sun 6.30pm"
      
      # Wednesday
      parser.performances_for_day(Date.new(2010, 3, 31)).should == [
        Time.local(2010, 3, 31, 18, 30)
      ]
      
      # Thursday
      parser.performances_for_day(Date.new(2010, 4, 1)).should == [
        Time.local(2010, 4, 1, 20, 0)
      ]
      
      # Sunday
      parser.performances_for_day(Date.new(2010, 4, 4)).should == [
        Time.local(2010, 4, 4, 18, 30)
      ]
    end
    
    it "should handle same times for different dates" do
      parser = LaughTrack::TimeParser.new "26 Mar 8pm & 27 Mar 8pm"
      parser.performances_for_day(Date.new(2010, 3, 27)).should == [
        Time.local(2010, 3, 27, 20, 0)
      ]
    end
    
    it "should handle multiple shows on the same day" do
      parser = LaughTrack::TimeParser.new "2pm & 5pm"
      parser.performances_for_day(Date.new(2010, 4, 1)).should == [
        Time.local(2010, 4, 1, 14, 0),
        Time.local(2010, 4, 1, 17, 0)
      ]
    end
    
    it "should handle shows with some double show days and some not" do
      parser = LaughTrack::TimeParser.new "Tue-Sun 2pm & Sat 5pm"
      
      # Tuesday
      parser.performances_for_day(Date.new(2010, 3, 30)).should == [
        Time.local(2010, 3, 30, 14, 0)
      ]
      
      # Saturday
      parser.performances_for_day(Date.new(2010, 3, 27)).should == [
        Time.local(2010, 3, 27, 14, 0),
        Time.local(2010, 3, 27, 17, 0)
      ]
    end
    
    it "should handle days separated by commas and ampersands" do
      parser = LaughTrack::TimeParser.new "Wed, Fri & Sun 6.30pm, Thu & Sat 8.30pm"
      
      # Wednesday
      parser.performances_for_day(Date.new(2010, 3, 31)).should == [
        Time.local(2010, 3, 31, 18, 30)
      ]
      
      # Thursday
      parser.performances_for_day(Date.new(2010, 4, 1)).should == [
        Time.local(2010, 4, 1, 20, 30)
      ]
      
      # Friday
      parser.performances_for_day(Date.new(2010, 4, 2)).should == [
        Time.local(2010, 4, 2, 18, 30)
      ]
      
      # Saturday
      parser.performances_for_day(Date.new(2010, 4, 3)).should == [
        Time.local(2010, 4, 3, 20, 30)
      ]
      
      # Sunday
      parser.performances_for_day(Date.new(2010, 4, 4)).should == [
        Time.local(2010, 4, 4, 18, 30)
      ]
    end
    
    it "should handle mixes of ranges and single days" do
      parser = LaughTrack::TimeParser.new "Tue-Thu & Sun 8pm, Fri 7.30pm"
      
      # Wednesday
      parser.performances_for_day(Date.new(2010, 3, 31)).should == [
        Time.local(2010, 3, 31, 20, 0)
      ]
      
      # Friday
      parser.performances_for_day(Date.new(2010, 4, 2)).should == [
        Time.local(2010, 4, 2, 19, 30)
      ]
      
      # Sunday
      parser.performances_for_day(Date.new(2010, 4, 4)).should == [
        Time.local(2010, 4, 4, 20, 0)
      ]
    end
    
    it "should handle multiple ranges for one time" do
      # Was Fri-Sat, but changed to Thu-Sat to make testing more thorough
      parser = LaughTrack::TimeParser.new "Mon-Wed & Thu-Sat 8.30pm, Sun 7.30pm"
      
      # Tuesday
      parser.performances_for_day(Date.new(2010, 3, 30)).should == [
        Time.local(2010, 3, 30, 20, 30)
      ]
      
      # Friday
      parser.performances_for_day(Date.new(2010, 4, 2)).should == [
        Time.local(2010, 4, 2, 20, 30)
      ]
      
      # Sunday
      parser.performances_for_day(Date.new(2010, 4, 4)).should == [
        Time.local(2010, 4, 4, 19, 30)
      ]
    end
    
    it "should return nothing if there's no times" do
      parser = LaughTrack::TimeParser.new("Unknown")
      parser.performances_for_day(Date.new(2010, 4, 1)).should be_empty
    end
    
    it "should understand 12noon" do
      parser = LaughTrack::TimeParser.new("Sat 12noon")
      parser.performances_for_day(Date.new(2010, 3, 27)).should == [
        Time.local(2010, 3, 27, 12, 0)
      ]
    end
  end
end
