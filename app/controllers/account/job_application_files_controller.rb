class Account::JobApplicationFilesController < Account::BaseController
  before_action :set_job_application
  before_action :set_job_application_file, only: %i(show)

  # GET /account/job_application_files
  # GET /account/job_application_files.json
  def index
  end

  # POST /account/job_application_files
  # POST /account/job_application_files.json
  def create
    @job_application_file = @job_application.job_application_files.build(job_application_file_params)

    respond_to do |format|
      if @job_application_file.save
        format.html { redirect_to @job_application_file, notice: t('.success') }
        format.js {
          @notification = t('.success')
          render :file_operation
        }
        format.json { render :show, status: :created, location: [:account, @job_application, @job_application_file] }
      else
        format.html { render :new }
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @job_application_file = @job_application.job_application_files.find params[:id]

    respond_to do |format|
      if @job_application_file.update(job_application_file_params)
        format.html { redirect_to @job_application_file, notice: t('.success') }
        format.js {
          @notification = t('.success')
          render :file_operation
        }
        format.json { render :show, status: :created, location: [:account, @job_application, @job_application_file] }
      else
        format.html { render :new }
        format.json { render json: @job_application_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    unless @job_application_file.content.file.present?
      return render json: {
        error: 'not found',
      }, status: :not_found
    end

    if ENV['OS_AUTH_URL'].present?
      url = @job_application_file.content.url
      uri = URI(url)
      if uri.scheme.blank?
        uri = URI('https:' + uri.to_s)
      end
      response.headers['Content-Type'] = 'application/pdf'
      response.headers['Content-Disposition'] = "inline; filename=\"#{action_name}.pdf\""
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
      send_file(@job_application_file.content.path,
        disposition: 'inline',
        filename: "#{action_name}.pdf",
        type: 'application/pdf')
    end
  ensure
    response.stream.close if response.stream.respond_to?(:close)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_file_params
      params.require(:job_application_file).permit(:job_application_file_type_id, :content)
    end

    def set_job_application
      @job_application = current_user.job_applications.find(params[:job_application_id])
      @job_offer = @job_application.job_offer
    end

    def set_job_application_file
      @job_application_file = @job_application.job_application_files.find params[:id]
    end
end
