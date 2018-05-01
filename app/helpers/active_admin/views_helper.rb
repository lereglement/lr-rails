module ActiveAdmin::ViewsHelper #camelized file name

  def time_ago(date)
    if date
      if date.to_date === Time.now.to_date
        "Today, #{date.strftime("%Hh%M")}"
      else
        days = (Time.now.to_date - date.to_date).to_i
        "#{days} day#{days < 2 ? "" : "s"} ago"
      end
    end
  end

end
