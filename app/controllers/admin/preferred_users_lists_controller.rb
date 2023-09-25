# frozen_string_literal: true

class Admin::PreferredUsersListsController < Admin::InheritedResourcesController
  layout "admin/pool"

  def index
  end

  def show
    @preferred_users = @preferred_users_list.users.includes(:job_applications)
    @q = @preferred_users.ransack(params[:q])
    @preferred_users_filtered = @q.result.yield_self { |relation|
      if params[:s].present?
        relation.search_full_text(params[:s])
      else
        relation
      end
    }.yield_self { |relation|
      relation.paginate(page: params[:page])
    }

    render action: :show, layout: "admin/pool"
  end

  def new
    render layout: request.xhr? ? false : "admin/pool"
  end

  def edit
    render layout: request.xhr? ? false : "admin/pool"
  end

  def create
    if resource.save
      respond_to do |format|
        format.html { redirect_to [:admin, resource] }
        format.js { render json: {}.to_json, status: :created, location: [:admin, resource] }
      end
    else
      layout_choice = request.xhr? ? false : "admin/pool"
      render action: "new", status: :unprocessable_entity, layout: layout_choice
    end
  end

  def update
    if resource.update(permitted_params)
      respond_to do |format|
        format.html { redirect_to [:admin, resource] }
        format.js { render json: {}.to_json, status: :created, location: [:admin, resource] }
      end
    else
      respond_to do |format|
        format.html do
          layout_choice = request.xhr? ? false : "admin/pool"
          render action: "edit", status: :unprocessable_entity, layout: layout_choice
        end
      end
    end
  end

  def export
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

  def destroy
    @preferred_users_list.destroy

    redirect_to %i[admin users]
  end

  def send_job_offer
    preferred_users_list = PreferredUsersList.find(params[:id])
    job_offer = JobOffer.find_by(identifier: params["job_offer_identifier"])

    if job_offer&.send_to_users(preferred_users_list.users)
      redirect_back(fallback_location: [:admin, preferred_users_list], notice: t(".success"))
    else
      redirect_back(fallback_location: [:admin, preferred_users_list], notice: t(".error"))
    end
  end

  protected

  def permitted_fields
    %i[name note]
  end
end
