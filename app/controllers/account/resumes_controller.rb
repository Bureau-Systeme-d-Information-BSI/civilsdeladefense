class Account::ResumesController < Account::BaseController
  def show
    send_data(
      profile.resume.read,
      filename: profile.resume_file_name,
      type: "application/pdf",
      disposition: "inline"
    )
  ensure
    response.stream.close if response.stream.respond_to?(:close)
  end

  private

  def profile = @profile ||= current_user.profile.presence
end
