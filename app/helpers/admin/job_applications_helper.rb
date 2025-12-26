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
    @job_applications_tab_active ||= if controller.controller_name == "job_applications"
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

  def job_application_resume_url(job_application)
    return unless job_application

    target_state = JobApplication.states["initial"]
    target_file_type = JobApplicationFileType.where(from_state: target_state, kind: :applicant_provided)
    job_application_files = job_application.job_application_files.where(job_application_file_type: target_file_type).joins(:job_application_file_type).order("job_application_file_types.position")
    job_application_file = job_application_files.limit(1).first
    if job_application_file&.document_content&.present?
      url_for([:admin, job_application, job_application_file, {format: :pdf}])
    end
  end
end
