# frozen_string_literal: true

require "will_paginate/view_helpers/action_view"

# Custom will_paginate renderer to conform with the French state Design System
class RfRenderer < WillPaginate::ActionView::LinkRenderer
  def to_html
    html = pagination.map { |item|
      item.is_a?(Integer) ? page_number(item) : send(item)
    }.join(@options[:link_separator])

    @options[:class] ||= ""
    @options[:class] += " fr-pagination__list"

    ul = tag("ul", html, class: @options[:class])
    tag("nav", ul, class: "fr-pagination", 'aria-label': "Pagination navigation")
  end

  protected

  def page_item(text, url, current: false)
    tag(:li, generate_link(text, url, current))
  end

  def page_number(page)
    page_item(page, page, current: page == current_page)
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { "&hellip;" }
    page_item(text, nil)
  end

  def previous_page
    num = @collection.current_page > 1 ? @collection.current_page - 1 : nil
    previous_or_next_page(num, @options[:previous_label], "Previous")
  end

  def next_page
    num = @collection.current_page < total_pages ? @collection.current_page + 1 : nil
    previous_or_next_page(num, @options[:next_label], "Next")
  end

  def previous_or_next_page(page, text, _aria_label)
    page_item(text, page)
  end

  def generate_link(text, url, current)
    link(
      text,
      url,
      class: "fr-pagination__link",
      rel: text,
      title: "Page #{text}",
      'aria-label': "Page #{text}",
      'data-controller': "scroll",
      'data-action': "scroll#top",
      'aria-current': current ? "page" : nil
    )
  end
end
