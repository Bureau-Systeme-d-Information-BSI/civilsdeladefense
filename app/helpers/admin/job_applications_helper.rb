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
      PersonalProfile.human_attribute_name("#{field}/#{content}")
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

  def personal_profile_fields1
    %i[gender birth_date address address_2 phone nationality has_residence_permit website_url]
  end

  def personal_profile_fields2
    %i[is_currently_employed availability_date_in_month study_level study_type specialization
       experience_level has_corporate_experience]
  end

  def personal_profile_fields3
    %i[skills_fit_job_offer experiences_fit_job_offer]
  end

  def address_fields
    %i[address_1 postcode city country]
  end

  def choices_boolean
    [
      [PersonalProfile.human_attribute_name('is_currently_employed/true'), true],
      [PersonalProfile.human_attribute_name('is_currently_employed/false'), false]
    ]
  end

  def choices_month
    1.upto(12).to_a
  end

  def choices_gender
    PersonalProfile.genders.each_with_object([]) do |(k, _), ary|
      str = PersonalProfile.human_attribute_name("gender/#{k}")
      ary << [str, k]
    end
  end
end
