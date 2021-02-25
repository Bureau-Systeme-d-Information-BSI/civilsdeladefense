# frozen_string_literal: true

module ApplicationHelper
  def show_stats_debug?
    params[:debug].present?
  end

  def time_ago_in_words_minimal(time)
    res = time_ago_in_words(time)
    res.split(" ").map { |x|
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
    }.join(" ")
  end

  def spinner
    content_tag "div", class: "indeterminate-circle mini text-primary" do
      concat spinner_svg.html_safe
    end
  end

  def spinner_svg
    <<~HEREDOC
      <svg version="1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24" height="24" viewBox="0 0 24 24">
        <path id="indeterminate" d="M12 3.25A8.75 8.75 0 1 1 3.25 12" stroke-width="2.5" stroke-linecap="square" fill="none" stroke="currentColor"/>
      </svg>
    HEREDOC
  end

  def will_paginate(collection = nil, options = {})
    options[:renderer] ||= BootstrapRenderer
    super(collection, options)
  end
end
