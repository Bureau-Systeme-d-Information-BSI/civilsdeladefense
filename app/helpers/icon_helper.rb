# frozen_string_literal: true

module IconHelper
  def fa_icon(name, options = {})
    klasses = "svg-inline--fa fa-#{name}"
    klasses += ' fa-w-16' unless options[:class] && options[:class] =~ /fa-w-/
    klasses += ' ' + options[:class] if options[:class].present?
    options[:viewbox] ||= '0 0 512 512'
    title = options[:title].present? ? content_tag('title', options[:title]) : ''
    content = title.html_safe + content_tag('use', '', 'xlink:href' => "##{name}")
    content_tag 'svg',
                content,
                class: klasses,
                style: options[:style],
                'aria-hidden' => true,
                'role' => 'img',
                'xmlns' => 'http://www.w3.org/2000/svg',
                viewbox: options[:viewbox],
                data: options[:data]
  end

  def icon_for_controller(ary)
    key = ary.first
    case key
    when :job_offers
      :briefcase
    when :job_applications
      :'account-multiple'
    when :settings
      :settings
    when :stats
      :statistics
    end
  end
end
