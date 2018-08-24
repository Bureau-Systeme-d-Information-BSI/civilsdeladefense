class Admin::MessagesController < ApplicationController
  before_action :set_job_application

  # POST /admin/messages
  # POST /admin/messages.json
  def create
    @message = @job_application.messages.build(message_params)
    @message.administrator = current_administrator

    respond_to do |format|
      if @message.save
        format.html { redirect_to [:admin, @message.job_application], notice: t('.success') }
        format.js {
          @message = Message.new
          @message.job_application = @job_application
          @notification = t('.success')
          render :create
        }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = JobApplication.find(params[:job_application_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:body)
    end
end
