class Admin::EmailsController < Admin::BaseController
  load_and_authorize_resource :job_application
  load_and_authorize_resource :email, through: :job_application

  # POST /admin/emails
  # POST /admin/emails.json
  def create
    @email.sender = current_administrator
    @email.job_application = @job_application

    respond_to do |format|
      if @email.save
        ApplicantNotificationsMailer.new_email(@email.id).deliver_now

        format.html { redirect_to [:admin, @email.job_application], notice: t('.success') }
        format.js {
          @email = Email.new
          @email.job_application = @job_application
          @notification = t('.success')
          render :create
        }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_read
    @email.is_unread = false
    @email.save
    @job_application.reload

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application, @email], notice: t('.success')) }
      format.js {
        @notification = t('.success')
        render :email_operation
      }
      format.json { render json: @email.to_json, status: :ok, location: [:admin, @job_application, @email] }
    end
  end

  def mark_as_unread
    @email.is_unread = true
    @email.save
    @job_application.reload

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application, @email], notice: t('.success')) }
      format.js {
        @notification = t('.success')
        render :email_operation
      }
      format.json { render json: @email.to_json, status: :ok, location: [:admin, @job_application, @email] }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:subject, :body, attachments: [])
    end
end
