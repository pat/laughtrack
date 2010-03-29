class LaughTrack::TimeParser
  attr_accessor :time_parts
  
  def initialize(string)
    @string     = string.gsub(/12noon/, '12pm').strip
    @time_parts = []
    
    split_string_to_times
  end
  
  def times
    @times ||= just_times
  end
  
  def performances_for_day(day)
    return [day_with_time(day, times.first)]      if times.uniq.length == 1
    return [day_with_time(day, time_parts.first)] if time_parts.length == 1
    
    time_parts.select { |part|
      days(part).include?(day.wday)
    }.collect { |part|
      day_with_time(day, part)
    }
  end
  
  private
  
  def just_times
    @time_parts.collect { |part|
      part = part[/\d+(\.\d\d)?[ap]m/]
    }
  end
  
  def split_string_to_times
    string = @string.clone
    
    while !string.blank? && index = string.index(/\d+(\.\d\d)?[ap]m/)
      time_end     = string[/\d+(\.\d\d)?[ap]m/].length + index
      add_time_part  string[0..time_end]
      
      string = string[(time_end+1)..string.length]
    end
  end
  
  def add_time_part(part)
    @time_parts << part.gsub(/^[\s,\&]+/, '').gsub(/[\s,\&]+$/, '')
  end
  
  DayRegexes = [
    /\bMon\b/, /\bTue\b/, /\bWed\b/, /\bThu\b/, /\bFri\b/, /\bSat\b/, /\bSun\b/
  ]
  
  def days(string)
    days = []

    string.scan(/([A-Z][a-z][a-z])\s?\-\s?([A-Z][a-z][a-z])/) do |match|
      first, last = day_integer(match.first), day_integer(match.last)
      if first > last
        days += (first..6).to_a
        days += (0..last).to_a
      else
        days += (first..last).to_a
      end
    end
    
    DayRegexes.each do |pattern|
      match = string[pattern]
      days << day_integer(match) unless match.nil?
    end
    
    days.empty? ? 0..6 : days
  end
  
  def day_integer(string)
    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].index(string)
  end
  
  def day_with_time(day, time_string)
    match = time_string.scan(/((\d+)(\.\d\d)?([ap]m))/).first
    hour   = match[1].to_i
    minute = match[2].to_s.gsub(/^\./, '').to_i
    hour  += 12 if (match[3] == 'pm' && hour < 12)
    
    Time.local(day.year, day.month, day.mday, hour, minute)
  end
end
