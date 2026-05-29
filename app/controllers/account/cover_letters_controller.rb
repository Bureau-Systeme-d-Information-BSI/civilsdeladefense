# frozen_string_literal: true

class Account::CoverLettersController < Account::BaseController
  skip_load_and_authorize_resource

  def show
    send_data(
      job_application.cover_letter.read,
      filename: job_application.cover_letter_file_name,
      type: "application/pdf",
      disposition: "inline"
    )
  ensure
    response.stream.close if response.stream.respond_to?(:close)
  end

  private

  def job_application = @job_application ||= JobApplication.find(params[:job_application_id])
end
