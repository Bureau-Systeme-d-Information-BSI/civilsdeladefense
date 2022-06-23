# frozen_string_literal: true

class Admin::MultipleRecipientsEmailsController < Admin::BaseController
  load_and_authorize_resource :job_offer

  helper_method :is_form_disabled?

  def new
    @job_applications = @job_offer.job_applications.with_user.send(state)
  end

  def create
    if @multiple_recipients_email.save
      redirect_to [:board, :admin, @job_offer], notice: t(".success")
    else
      @job_applications = @job_offer.job_applications.where(id: @multiple_recipients_email.job_application_ids)
      render :new
    end
  end

  private

  def multiple_recipients_email_params
    params
      .require(:multiple_recipients_email)
      .permit(:subject, :body, job_application_ids: [], attachments: [])
      .merge(sender: current_administrator)
      .to_h
      .symbolize_keys
  end

  def state
    state_param = params[:state]
    if JobApplication.states.key?(state_param)
      state_param
    else
      JobApplication.states.keys.first
    end
  end

  def is_form_disabled?
    @job_offer.archived?
  end
end
