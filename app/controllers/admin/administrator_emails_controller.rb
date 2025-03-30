class Admin::AdministratorEmailsController < Admin::BaseController
  skip_load_and_authorize_resource

  helper_method :next_page

  def index = @administrators = administrators.page(params[:page]).per_page(10)

  private

  def administrators
    if params[:q].present?
      Administrator.search_email(params[:q])
    else
      Administrator.all
    end
  end

  def next_page = @administrators.next_page.presence
end
