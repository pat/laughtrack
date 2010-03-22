Time::DATE_FORMATS[:show_date] = lambda { |time| time.strftime("#{time.day.ordinalize} %B") }
Time::DATE_FORMATS[:show_time] = "%H:%M %p"