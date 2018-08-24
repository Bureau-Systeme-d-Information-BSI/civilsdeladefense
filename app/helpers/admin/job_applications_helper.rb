module Admin::JobApplicationsHelper

  def job_application_modal_section_classes(additional_class = nil)
    case additional_class
    when 'pb-0'
      %w(px-4 pt-4).push(additional_class)
    else
      %w(px-4 py-4)
    end
  end
end
