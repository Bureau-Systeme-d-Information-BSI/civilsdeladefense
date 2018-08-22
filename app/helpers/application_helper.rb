module ApplicationHelper

  def time_ago_in_words_minimal(t)
    res = time_ago_in_words(t)
    res.split(" ").map do |x|
      case x
      when /min/
        "min"
      when /mois/
        "m"
      when /heure/
        "h"
      else
        x
      end
    end.join(" ")
  end
end
