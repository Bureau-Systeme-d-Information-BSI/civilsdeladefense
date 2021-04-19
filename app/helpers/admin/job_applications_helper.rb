# frozen_string_literal: true

module Admin::JobApplicationsHelper
  def job_application_modal_section_classes(additional_class = nil)
    case additional_class
    when "pb-0"
      %w[px-4 pt-4].push(additional_class)
    else
      %w[px-4 py-4]
    end
  end

  def job_applications_tab_active
    @job_applications_tab_active ||= begin
      if controller.controller_name == "job_applications"
        case controller.action_name
        when "show"
          :profile
        when "cvlm"
          :cvlm
        when "emails"
          :emails
        when "files"
          :files
        end
      end
    end
  end

  def in_place_edit_value_formatted(content, field)
    case field
    when :availability_date_in_month
      "#{content} mois"
    when :gender, :is_currently_employed
      Profile.human_attribute_name("#{field}/#{content}")
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

    return content_tag("em", "Non défini(e)") if res.to_s.blank?

    in_place_edit_value_formatted(res, m)
  end

  def choices_boolean
    [
      [Profile.human_attribute_name("is_currently_employed/true"), true],
      [Profile.human_attribute_name("is_currently_employed/false"), false]
    ]
  end

  def choices_gender
    Profile.genders.each_with_object([]) do |(k, _), ary|
      str = Profile.human_attribute_name("gender/#{k}")
      ary << [str, k]
    end
  end
end
