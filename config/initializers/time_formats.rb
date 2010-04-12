Time::DATE_FORMATS[:show_date] = lambda { |time| time.strftime("%a #{time.day.ordinalize} %B") }
Time::DATE_FORMATS[:show_time] = "%l:%M %p"
