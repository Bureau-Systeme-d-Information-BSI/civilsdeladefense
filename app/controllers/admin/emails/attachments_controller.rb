# frozen_string_literal: true

class Admin::Emails::AttachmentsController < Admin::BaseController
  skip_load_and_authorize_resource
  load_and_authorize_resource :job_application
  load_and_authorize_resource :email, through: :job_application

  def show
    content = @email.email_attachments.find(params[:id]).document_content

    send_data(
      content.read,
      filename: content.filename,
      type: content.content_type
    )
  end
end
