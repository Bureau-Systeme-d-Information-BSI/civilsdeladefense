# frozen_string_literal: true

module Admin::BaseHelper
  def datepicker_display(datetime)
    datetime&.to_date&.strftime('%d/%m/%Y')
  end

  def user_detailed_info_url(user, job_application)
    if job_application && can?(:manage, job_application)
      [:admin, job_application.job_offer, job_application]
    elsif can?(:manage, user)
      [:admin, @preferred_users_list, user]
    else
      '#'
    end
  end
end
