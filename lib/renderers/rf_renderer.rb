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
    tag("nav", ul, class: "rf-pagination", role: "navigation", "aria-label": "Pagination")
  end

  protected

  def page_number(page)
    if page == current_page
      link_in_li_tag(
        page,
        nil,
        "aria-current": "page"
      )
    else
      link_in_li_tag(
        page,
        page,
        rel: page,
        title: "Page #{page}",
        "aria-label": "Page #{page}",
        "data-controller": "scroll",
        "data-action": "scroll#top"
      )
    end
  end

  def gap
    link_in_li_tag(@template.will_paginate_translate(:page_gap) { "&hellip;" }, nil)
  end

  def previous_page
    if (page = @collection.current_page > 1 && @collection.current_page - 1)
      link_in_li_tag(
        @options[:previous_label],
        page,
        "data-controller": "scroll",
        "data-action": "scroll#top"
      )
    else
      link_in_li_tag(@options[:previous_label], nil)
    end
  end

  def next_page
    if (page = @collection.current_page < total_pages && @collection.current_page + 1)
      link_in_li_tag(
        @options[:next_label],
        page,
        "data-controller": "scroll",
        "data-action": "scroll#top"
      )
    else
      link_in_li_tag(@options[:next_label], nil)
    end
  end

  private

  def link_in_li_tag(text, url, options = {})
    options[:class] = "rf-pagination__link #{options[:class]}"
    tag(:li, link(text, url, options))
  end
end
