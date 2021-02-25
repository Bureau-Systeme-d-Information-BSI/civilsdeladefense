# frozen_string_literal: true

class Admin::MessagesController < Admin::BaseController
  load_and_authorize_resource :job_application
  load_and_authorize_resource :message, through: :job_application

  # POST /admin/messages
  # POST /admin/messages.json
  def create
    @message.administrator = current_administrator
    @message.job_application = @job_application

    respond_to do |format|
      if @message.save
        format.html { redirect_to [:admin, @message.job_application], notice: t(".success") }
        format.js do
          @message = Message.new
          @message.job_application = @job_application
          @notification = t(".success")
          render :create
        end
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.js do
          @notification = t(".failure")
          render :new
        end
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:body)
  end
end
