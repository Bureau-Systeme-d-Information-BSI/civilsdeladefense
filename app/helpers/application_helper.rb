# frozen_string_literal: true

module ApplicationHelper
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
      concat spinner_svg.html_safe # rubocop:disable Rails/OutputSafety
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

  # Deactivate Turbo on form by default
  def simple_form_for(object, *args, &block)
    options = args.extract_options!
    options[:html] ||= {}
    options[:data] ||= {}
    if options[:html]["data-turbo"].blank? && options[:data][:turbo].blank?
      options[:data][:turbo] = false
    end
    super(object, *(args << options), &block)
  end

  def header_offers_active?(controller_name, action_name, job_offer: nil)
    controller_name == "job_offers" &&
      (action_name == "index" || (action_name == "show" && !job_offer.spontaneous?)) &&
      request.params[:bookmarked].blank?
  end

  def header_spontaneous_active?(controller_name, action_name, job_offer: nil)
    controller_name == "job_offers" && action_name == "show" && job_offer&.spontaneous?
  end

  def header_bookmarks_active?(controller_name, action_name)
    controller_name == "job_offers" && action_name == "index" && request.params[:bookmarked].present?
  end
end
