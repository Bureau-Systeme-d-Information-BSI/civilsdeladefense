class Admin::JobApplicationFilesController < Admin::BaseController
  # Add the ability to stream data
  # (http://guides.rubyonrails.org/action_controller_overview.html#live-streaming-of-arbitrary-data)
  include ActionController::Live

  load_and_authorize_resource :job_application
  load_and_authorize_resource :job_application_file, through: :job_application

  def show
    if !@job_application_file.content.present?
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
      #response.headers['Content-Length'] = @job_application_file.send("#{action_name}_file_size")
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

  def check
    @job_application_file.update_column :is_validated, 1
    @job_application.compute_notifications_counter!

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application, @job_application_file], notice: t('.success', state: state_i18n)) }
      format.js {
        @notification = t('.success')
        render :file_operation
      }
      format.json { render :show, status: :ok, location: [:admin, @job_application, @job_application_file] }
    end
  end

  def uncheck
    @job_application_file.update_column :is_validated, 2
    @job_application.compute_notifications_counter!

    respond_to do |format|
      format.html { redirect_back(fallback_location: [:admin, @job_application, @job_application_file], notice: t('.success', state: state_i18n)) }
      format.js {
        @notification = t('.success')
        render :file_operation
      }
      format.json { render :show, status: :ok, location: [:admin, @job_application, @job_application_file] }
    end
  end
end
