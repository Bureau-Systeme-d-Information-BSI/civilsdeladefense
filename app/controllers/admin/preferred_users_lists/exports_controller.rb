# frozen_string_literal: true

class Admin::PreferredUsersLists::ExportsController < Admin::BaseController
  skip_load_and_authorize_resource
  before_action :set_preferred_users_list
  before_action :authorize_export

  def show
    respond_to do |format|
      format.xlsx do
        file = Exporter::Users.new(
          @preferred_users_list.users,
          current_administrator,
          name: @preferred_users_list.name
        ).generate
        send_data file.read, filename: "#{Time.zone.today}_e-recrutement_vivers.xlsx"
      end
      format.zip do
        zip_id = SecureRandom.uuid
        ZipJobApplicationFilesJob.perform_later(zip_id: zip_id, user_ids: @preferred_users_list.users.pluck(:id))
        redirect_to admin_zip_file_path(zip_id)
      end
    end
  end

  private

  def set_preferred_users_list
    @preferred_users_list = PreferredUsersList.find(params[:preferred_users_list_id])
  end

  def authorize_export
    authorize! :export, @preferred_users_list
  end
end
