# frozen_string_literal: true

module SendFileContent
  extend ActiveSupport::Concern
  include ActionController::Live

  def send_job_application_file_content
    send_data(
      @job_application_file.document_content.read,
      filename: "#{action_name}.pdf",
      type: "application/pdf",
      disposition: "inline"
    )
  ensure
    response.stream.close if response.stream.respond_to?(:close)
  end
end
