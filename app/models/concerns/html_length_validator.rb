class HtmlLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    without_html = ActionView::Base.full_sanitizer.sanitize(value)
    length = without_html&.length || 0

    if options[:maximum] && length > options[:maximum]
      record.errors.add(attribute, (options[:message] || :too_long))
    end
  end
end
