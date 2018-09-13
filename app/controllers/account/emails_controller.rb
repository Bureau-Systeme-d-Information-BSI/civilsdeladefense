class Account::EmailsController < Account::BaseController
  before_action :set_job_application

  # GET /account/emails
  # GET /account/emails.json
  def index
    @emails = @job_application.emails.order(created_at: :desc)
    @email = @job_application.emails.new
  end

  # POST /account/emails
  # POST /account/emails.json
  def create
    @email = @job_application.emails.build(email_params)
    @email.sender = current_user
    @email.job_application = @job_application

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: t('.success') }
        format.js {
          @email = Email.new
          @email.job_application = @job_application
          @notification = t('.success')
          render :create
        }
        format.json { render :show, status: :created, location: [:account, @job_application, @email] }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:subject, :body)
    end

    def set_job_application
      @job_application = current_user.job_applications.find(params[:job_application_id])
      @job_offer = @job_application.job_offer
    end
end
