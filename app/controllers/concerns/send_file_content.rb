# frozen_string_literal: true

module SendFileContent
  extend ActiveSupport::Concern
  include ActionController::Live

  def send_job_application_file_content
    if ENV['OS_AUTH_URL'].present?
      proxy_job_application_file_content
    else
      send_content_directly
    end
  ensure
    response.stream.close if response.stream.respond_to?(:close)
  end

  protected

  def send_content_directly
    send_file(@job_application_file.content.path,
              disposition: 'inline',
              filename: "#{action_name}.pdf",
              type: 'application/pdf')
  end

  def proxy_job_application_file_content
    url = @job_application_file.content.url
    uri = URI(url)
    uri = URI('https:' + uri.to_s) if uri.scheme.blank?
    response.headers['Content-Type'] = 'application/pdf'
    response.headers['Content-Disposition'] = "inline; filename=\"#{action_name}.pdf\""
    # Download the backup file chunk by chunk and forward each chunk to the client.
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new(uri.request_uri)
      # req.basic_auth uri.user, uri.password
      http.request req do |res|
        # Read fragment of the body from the socket.
        # The variable `c` contains the fragment's bytes.
        # I am not really sure about the size of the fragments or how to specify it.
        res.read_body do |c|
          response.stream.write c
        end
      end
    end
  end
end
