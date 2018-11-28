class Admin::JobApplicationsController < Admin::BaseController
  # Add the ability to stream data
  # (http://guides.rubyonrails.org/action_controller_overview.html#live-streaming-of-arbitrary-data)
  include ActionController::Live

  before_action :serve_file_from_job_application, only: JobOffer::FILES
  before_action :serve_file_from_user, only: (User::FILES - JobOffer::FILES)
  before_action :serve_file, only: (JobOffer::FILES + User::FILES)

  # GET /admin/job_applications
  # GET /admin/job_applications.json
  def index
    @contract_types = ContractType.all
    @employers = Employer.all

    @job_applications = @job_applications.includes(:job_offer)

    %i(category_id contract_type_id).each do |filter|
      if params[filter].present? && (obj = filter.to_s.gsub('_id', '').classify.constantize.find(params[filter])).present?
        @job_applications = @job_applications.where(job_offers: {filter => obj.id})
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", obj)
      end
    end
    %i(employer_id).each do |filter|
      if params[filter].present? && (obj = filter.to_s.gsub('_id', '').classify.constantize.find(params[filter])).present?
        @job_applications = @job_applications.where(filter => obj.id)
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", obj)
      end
    end
    %i(state).each do |filter|
      if params[filter].present?
        @job_applications = @job_applications.where(filter => params[filter])
        instance_variable_set("@#{ filter.to_s.gsub('_id', '') }", params[filter])
      end
    end
    @job_applications = @job_applications.search_full_text(params[:q]) if params[:q].present?
    @job_applications = @job_applications.paginate(page: params[:page], per_page: 25)
  end

  # GET /admin/job_applications/1
  # GET /admin/job_applications/1.json
  def show
    @other_job_applications = @job_application.user.job_applications.where.not(id: @job_application.id)
    render layout: request.xhr? ? false : "admin/simple"
  end

  # GET /admin/job_applications/new
  def new
  end

  # GET /admin/job_applications/1/edit
  def edit
  end

  # POST /admin/job_applications
  # POST /admin/job_applications.json
  def create
    respond_to do |format|
      if @job_application.save
        format.html { redirect_to [:admin, @job_application], notice: 'Job application was successfully created.' }
        format.json { render :show, status: :created, location: @job_application }
      else
        format.html { render :new }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/job_applications/1
  # PATCH/PUT /admin/job_applications/1.json
  def update
    respond_to do |format|
      if @job_application.update(job_application_params)
        format.html { redirect_to [:admin, @job_application], notice: 'Job application was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_application }
      else
        format.html { render :edit }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/job_applications/1
  # DELETE /admin/job_applications/1.json
  def destroy
    @job_application.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, :job_applications], notice: 'Job application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_state
    @state = params[:state].to_s
    @job_application.send("#{ @state }!".to_sym)
    @job_offer = @job_application.job_offer
    state_i18n = JobApplication.human_attribute_name("state/#{ @state }")

    val = @job_offer.job_applications.where(job_offer_id: @job_offer.id).select(:state, :created_at).group(:state).map{|x| x.state_before_type_cast}.max
    if @job_offer.most_advanced_job_applications_state_before_type_cast != val
      @job_offer.update_column(:most_advanced_job_applications_state, val)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application], notice: t('.success', state: state_i18n)) }
      format.js {
        @notification = t('.success', state: state_i18n)
        render :change_state
      }
      format.json { render :show, status: :ok, location: @job_application }
    end
  end

  def check_file
    @file_name = params[:file_name]
    if %i(resume cover_letter).include?(@file_name.to_sym)
      @job_application.update_column("#{ @file_name }_is_validated", 1)
      @job_application.compute_notifications_counter!
    else
      @job_application.user.update_column("#{ @file_name }_is_validated", 1)
      @job_application.user.job_applications.each &:compute_notifications_counter!
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application], notice: t('.success', state: state_i18n)) }
      format.js {
        @notification = t('.success')
        render :file_operation
      }
      format.json { render :show, status: :ok, location: [:admin, @job_application] }
    end
  end

  def uncheck_file
    @file_name = params[:file_name]
    if %i(resume cover_letter).include?(@file_name.to_sym)
      @job_application.update_column("#{ @file_name }_is_validated", 2)
      @job_application.compute_notifications_counter!
    else
      @job_application.user.update_column("#{ @file_name }_is_validated", 2)
      @job_application.user.job_applications.each &:compute_notifications_counter!
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application], notice: t('.success', state: state_i18n)) }
      format.js {
        @notification = t('.success')
        render :file_operation
      }
      format.json { render :show, status: :ok, location: [:admin, @job_application] }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = JobApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_application_params
      params.require(:job_application).permit(:job_offer_id, :user_id, :first_name, :last_name, :current_position, :phone, :address_1, :address_2, :postal_code, :city, :country, :website_url)
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
