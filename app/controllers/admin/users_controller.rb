# frozen_string_literal: true

class Admin::UsersController < Admin::InheritedResourcesController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_index

  def index
    pq = params[:q] || {}
    pq[:concerned] = current_administrator if pq[:concerned]
    @q = @users.ransack(pq)
    users = @q.result.includes(:profile, :job_applications)
    users = users.search_full_text(params[:s]) if params[:s].present?
    @users_filtered = users.paginate(page: params[:page], per_page: 25).to_a

    render action: :index, layout: "admin/pool"
  end

  def multi_select
    users = params[:select_all].present? ? User.all : User.where(id: params[:user_ids])
    if params.key?("add_to_list")
      lists = current_administrator.preferred_users_lists.where(id: params[:list_ids])
      lists.each do |list|
        list.update(users: [users, list.users].flatten.uniq)
      end
      if lists.any?
        redirect_to [:admin, lists.first]
      else
        redirect_to [:admin, :users]
      end
    elsif params.key?("export")
      file = Exporter::Users.new(users, current_administrator).generate
      send_data file.read, filename: "#{Time.zone.today}_e-recrutement_vivers.xlsx"
    elsif params.key?("resumes")
      zip_id = SecureRandom.uuid
      ZipJobApplicationFilesJob.perform_later(zip_id: zip_id, user_ids: users.pluck(:id))
      redirect_to admin_zip_file_path(zip_id)
    elsif params.key?("send_job_offer")
      job_offer = JobOffer.find_by(identifier: params["job_offer_identifier"])

      if job_offer&.send_to_users(users)
        redirect_back_or_to([:admin, :users], notice: t(".success"))
      else
        redirect_back_or_to([:admin, :users], notice: t(".error"))
      end
    end
  end

  def show
    render layout: "admin/pool"
  end

  def listing
    render layout: "admin/pool"
  end

  def update_listing
    if @user.update(permitted_params_listing)
      respond_to do |format|
        format.html do
          redirect_to %i[admin users], notice: t(".success")
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: :listing
        end
      end
    end
  end

  def photo
    send_data(
      @user.photo.big.read,
      filename: @user.photo.filename,
      type: @user.photo.content_type
    )
  end

  def destroy
    if @user.destroy
      redirect_back_or_to(%i[admin users], notice: t(".success"))
    else
      reason = @user.errors.full_messages.join(", ")
      redirect_back_or_to(%i[admin users], notice: t(".failure", reason: reason))
    end
  end

  protected

  def permitted_params_listing
    params.require(:user).permit(preferred_users_list_ids: [])
  end

  private

  def redirect_to_index
    redirect_to admin_users_path
  end
end
