class Admin::UnfavoritesController < Admin::BaseController
  skip_load_and_authorize_resource
  load_and_authorize_resource :job_application

  def create
    @job_application.preselect_as_unfavorite!
    redirect_back_or_to [:admin, @job_application]
  end

  def destroy
    @job_application.unpreselect_as_unfavorite!
    redirect_back_or_to [:admin, @job_application]
  end
end