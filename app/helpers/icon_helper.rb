# frozen_string_literal: true

module IconHelper
  def fa_icon(name, options = {})
    flavor = options[:flavor].presence || "solid"
    klasses = "fa-#{flavor} fa-#{name}"
    klasses += " #{options[:class]}" if options[:class].present?
    content_tag "i", nil, class: klasses, data: options[:data]
  end

  def icon_for_controller(ary)
    key = ary.first
    case key
    when :job_offers
      :briefcase
    when :users
      :users
    when :settings
      :gear
    when :stats
      :"chart-simple"
    end
  end
end
