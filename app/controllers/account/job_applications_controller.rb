class Account::JobApplicationsController < Account::BaseController
  before_action :set_job_application, except: %i(index finished)
  before_action :set_job_applications, only: %i(index finished)

  # Add the ability to stream data
  # (http://guides.rubyonrails.org/action_controller_overview.html#live-streaming-of-arbitrary-data)
  include ActionController::Live

  before_action :serve_file_from_job_application, only: JobOffer::FILES
  before_action :serve_file_from_user, only: (User::FILES - JobOffer::FILES)
  before_action :serve_file, only: (JobOffer::FILES + User::FILES)

  # GET /account/job_applications
  # GET /account/job_applications.json
  def index
    @job_applications = @job_applications_active
  end

  # GET /account/job_applications/finished
  # GET /account/job_applications/finished.json
  def finished
    @job_applications = @job_applications_finished

    render action: :index
  end

  # GET /account/job_applications/1
  # GET /account/job_applications/1.json
  def show
    @emails = @job_application.emails.order(created_at: :desc)
    @email = @job_application.emails.new

    render layout: request.xhr? ? false : true
  end

  def update
    @file_name = job_application_params.keys.first

    respond_to do |format|
      if @job_application.update(job_application_params)
        @job_application.update_column "#{@file_name}_is_validated", 0
        format.html { redirect_to [:account, @job_application], notice: t('.success') }
        format.js {}
        format.json { render :show, status: :ok, location: [:account, @job_application] }
      else
        format.html { render :edit }
        format.js {}
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  JobOffer::FILES.each do |field|
    define_method(field) do
    end
  end

  User::FILES.each do |field|
    define_method(field) do
    end
  end

  private

    def set_job_applications
      @job_applications_active = job_applications_root.not_finished
      @job_applications_finished = job_applications_root.finished
    end

    def job_applications_root
      current_user.job_applications.includes(job_offer: [:contract_type]).order(created_at: :desc)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = current_user.job_applications.find(params[:job_application_id] || params[:id])
      @job_offer = @job_application.job_offer
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_params
      params.require(:job_application).permit(:resume, :cover_letter)
    end

    def serve_file_from_job_application
      @reference_object = @job_application
    end

    def serve_file_from_user
      @reference_object = @job_application.user
    end

    def serve_file
      if !@reference_object.send(action_name).present?
        return render json: {
          error: 'not found',
        }, status: :not_found
      end

      if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present? && ENV['AWS_REGION'].present? && ENV['AWS_BUCKET_NAME'].present?
        url = @reference_object.send(action_name).url
        uri = URI(url)
        if uri.scheme.blank?
          uri = URI('https:' + uri.to_s)
        end
        response.headers['Content-Type'] = 'application/pdf'
        response.headers['Content-Disposition'] = "inline; filename=\"#{action_name}.pdf\""
        response.headers['Content-Length'] = @reference_object.send("#{action_name}_file_size")
        # Download the backup file chunk by chunk and forward each chunk to the client.
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          req = Net::HTTP::Get.new(uri.request_uri)
          # req.basic_auth uri.user, uri.password
          http.request req do |res|
            # Read fragment of the body from the socket. The variable `c` contains the fragment's bytes.
            # I am not really sure about the size of the fragments or how to specify it.
            res.read_body do |c|
              response.stream.write c
            end
          end
        end
      else
        send_file(@reference_object.send(action_name).path,
          disposition: 'inline',
          filename: "#{action_name}.pdf",
          type: 'application/pdf')
      end
    ensure
      response.stream.close if response.stream.respond_to?(:close)
    end
end
