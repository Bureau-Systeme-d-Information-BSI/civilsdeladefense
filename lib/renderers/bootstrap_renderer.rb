# frozen_string_literal: true

class BootstrapRenderer < WillPaginate::ActionView::LinkRenderer
  def to_html
    html = pagination.map do |item|
      item.is_a?(Integer) ? page_number(item) : send(item)
    end.join(@options[:link_separator])

    @options[:class] ||= ''
    @options[:class] +=  ' justify-content-center'

    tag('nav', tag('ul', html, class: @options[:class]))
  end

  protected

  def page_item(text, url, link_status = nil)
    text = text.to_s + tag(:span, '(current)', class: 'sr-only') if link_status == 'active'
    link_tag = link(text, url, class: 'page-link', rel: text) if link_status.nil?
    link_tag ||= tag(:span, text, class: 'page-link')

    tag(:li, link_tag, class: "page-item #{link_status}")
  end

  def page_number(page)
    link_status = 'active' if page == current_page
    page_item(page, page, link_status)
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
    page_item(text, nil, 'disabled')
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, @options[:previous_label], 'Previous')
  end

  def next_page
    num = @collection.current_page < total_pages && @collection.current_page + 1
    previous_or_next_page(num, @options[:next_label], 'Next')
  end

  def previous_or_next_page(page, text, _aria_label)
    link_status = 'disabled' unless page
    page_item(text, page, link_status)
  end
end
