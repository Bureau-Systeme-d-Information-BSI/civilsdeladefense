# frozen_string_literal: true

module Admin::BaseHelper
  def datepicker_display(datetime)
    datetime&.to_date&.strftime('%d/%m/%Y')
  end

  def job_application_user_modal_link_url(user, job_application)
    if job_application && can?(:manage, job_application)
      [:admin, job_application]
    elsif can?(:manage, user)
      existing_preferred_user = user.preferred_users.detect do |x|
        x.preferred_users_list_id == @preferred_users_list.id
      end
      [:admin, @preferred_users_list, existing_preferred_user]
    else
      '#'
    end
  end

  def job_application_user_modal_link_options(user, job_application)
    data_hash = { toggle: :modal, target: '#remoteContentModal' }
    if (job_application && can?(:manage, job_application)) || can?(:manage, user)
      { class: 'job-application-modal-link', data: data_hash }
    else
      {}
    end
  end
end
