module ActiveAdmin::ViewsHelper #camelized file name

  def time_ago(date)
    if date
      if Time.at(date).to_date === Time.now.to_date
        "Today, #{Time.at(date).strftime("%Hh %M")}"
      else
        "#{distance_of_time_in_words(Time.now, date, highest_measure_only: true)} ago"
      end
    end
  end

end
