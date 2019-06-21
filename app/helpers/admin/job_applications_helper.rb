# frozen_string_literal: true

module Admin::JobApplicationsHelper
  def job_application_modal_section_classes(additional_class = nil)
    case additional_class
    when 'pb-0'
      %w[px-4 pt-4].push(additional_class)
    else
      %w[px-4 py-4]
    end
  end

  def in_place_edit_value_formatted(content, field)
    case field
    when :birth_date
      "Né(e) le #{I18n.l(content)}"
    when :availability_date_in_month
      "#{content} mois"
    when :nationality
      c = ISO3166::Country.new(content)
      c.translations[I18n.locale.to_s]
    when :gender, :is_currently_employed
      User.human_attribute_name("#{field}/#{content}")
    else
      content
    end
  end

  def in_place_edit_value(obj, opts = {})
    res = nil

    if (m = opts.delete(:field))
      res = obj.send(m)
    elsif (association = opts.delete(:association))
      res = obj.send(association)&.name
    end

    return content_tag('em', 'Non défini(e)') if res.blank?

    in_place_edit_value_formatted(res, m)
  end
end
