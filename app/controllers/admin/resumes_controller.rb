class Admin::ResumesController < Admin::BaseController
  skip_load_and_authorize_resource

  def show
    send_data(
      user.profile.resume.read,
      filename: "resume.pdf",
      type: "application/pdf",
      disposition: "inline"
    )
  ensure
    response.stream.close if response.stream.respond_to?(:close)
  end

  private

  def user = @user ||= User.find(params[:user_id])
end
