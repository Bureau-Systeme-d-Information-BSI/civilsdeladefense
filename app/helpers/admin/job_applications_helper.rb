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

  def job_applications_tab_active
    params[:tabopen].present? ? params[:tabopen].to_sym : :profile
  end

  def in_place_edit_value_formatted(content, field)
    case field
    when :availability_date_in_month
      "#{content} mois"
    when :gender, :is_currently_employed
      UserProfile.human_attribute_name("#{field}/#{content}")
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

    return content_tag('em', 'Non défini(e)') if res.to_s.blank?

    in_place_edit_value_formatted(res, m)
  end

  def user_profile_fields1
    %i[gender phone website_url]
  end

  def user_profile_fields2
    %i[is_currently_employed age_range availability_range study_level
       experience_level has_corporate_experience]
  end

  def job_application_profile_fields
    %i[skills_fit_job_offer experiences_fit_job_offer]
  end

  def choices_boolean
    [
      [UserProfile.human_attribute_name('is_currently_employed/true'), true],
      [UserProfile.human_attribute_name('is_currently_employed/false'), false]
    ]
  end

  def choices_gender
    UserProfile.genders.each_with_object([]) do |(k, _), ary|
      str = UserProfile.human_attribute_name("gender/#{k}")
      ary << [str, k]
    end
  end
end
