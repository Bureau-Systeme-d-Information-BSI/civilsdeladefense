# frozen_string_literal: true

require "will_paginate/view_helpers/action_view"

# Custom will_paginate renderer to conform with the French state Design System
class RfRenderer < WillPaginate::ActionView::LinkRenderer
  def to_html
    html = pagination.map { |item|
      item.is_a?(Integer) ? page_number(item) : send(item)
    }.join(@options[:link_separator])

    @options[:class] ||= ""
    @options[:class] += " rf-pagination__list"

    ul = tag("ul", html, class: @options[:class])
    tag("nav", ul, class: "rf-pagination", "aria-label": "Pagination navigation")
  end

  protected

  def page_item(text, url, link_status = nil)
    link_tag = generate_link(text, url) if link_status.nil?
    link_tag ||= tag(:span, text, class: "rf-pagination__label", "aria-current": "page")

    tag(:li, link_tag, class: "rf-pagination__item #{link_status}")
  end

  def page_number(page)
    link_status = "rf-pagination__item--active" if page == current_page
    page_item(page, page, link_status)
  end

  def gap
    tag(
      :li,
      link(
        @template.will_paginate_translate(:page_gap) { "&hellip;" },
        nil,
        class: "rf-pagination__link rf-displayed-lg"
      )
    )
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, @options[:previous_label], "Previous")
  end

  def next_page
    num = @collection.current_page < total_pages && @collection.current_page + 1
    previous_or_next_page(num, @options[:next_label], "Next")
  end

  def previous_or_next_page(page, text, _aria_label)
    link_status = "rf-pagination__item--disabled" unless page
    page_item(text, page, link_status)
  end

  def generate_link(text, url)
    link(
      text,
      url,
      class: "rf-pagination__link",
      rel: text,
      title: "Page #{text}",
      "aria-label": "Page #{text}",
      "data-controller": "scroll",
      "data-action": "scroll#top"
    )
  end
end
