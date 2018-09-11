class Admin::EmailsController < Admin::BaseController
  load_and_authorize_resource :job_application
  load_and_authorize_resource :email, through: :job_application

  # POST /admin/emails
  # POST /admin/emails.json
  def create
    @email.administrator = current_administrator
    @email.job_application = @job_application

    respond_to do |format|
      if @email.save
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:title, :body)
    end
end
