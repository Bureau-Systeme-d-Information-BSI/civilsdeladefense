# frozen_string_literal: true

class Admin::Settings::AdministratorsController < Admin::Settings::BaseController
  before_action :set_role_and_employer, only: %i[new create]
  before_action :set_administrators, only: %i[index inactive export]

  # GET /admin/settings/administrators
  # GET /admin/settings/administrators.json
  def index
    scope = @administrators_active
    @administrators_count = scope.size
    @administrators = scope.paginate(page: params[:page], per_page: 25)
  end

  def export
    @administrators = params[:active] ? @administrators_active : @administrators_inactive

    file = Exporter::Administrator.new(
      {data: @administrators, q: permitted_params[:q]},
      current_administrator
    ).generate

    send_data file.read, filename: "#{Time.zone.today}_e-recrutement_admins.xlsx"
  end

  # GET /admin/settings/administrators/inactive
  def inactive
    scope = @administrators_inactive
    @administrators_count = scope.size
    @administrators = scope.paginate(page: params[:page], per_page: 25)

    render action: :index
  end

  # GET /admin/settings/administrators/1
  # GET /admin/settings/administrators/1.json
  def show
  end

  # GET /admin/settings/administrators/new
  def new
  end

  # GET /admin/settings/administrators/1/edit
  def edit
  end

  # POST /admin/settings/administrators
  # POST /admin/settings/administrators.json
  def create
    @administrator.inviter = current_administrator
    @administrator.organization = current_organization
    respond_to do |format|
      if @administrator.save
        format.html { redirect_to %i[admin settings root], notice: t(".success") }
        format.json { render :show, status: :created, location: @administrator }
      else
        format.html { render :new }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/settings/administrators/1
  # PATCH/PUT /admin/settings/administrators/1.json
  def update
    respond_to do |format|
      if @administrator.update(administrator_params)
        format.html { redirect_to %i[admin settings root], notice: t(".success") }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :edit }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/settings/administrators/1/send_unlock_instructions
  # POST /admin/settings/administrators/1/send_unlock_instructions.json
  def send_unlock_instructions
    @administrator.send_unlock_instructions
    respond_to do |format|
      format.html { redirect_to %i[admin settings root], notice: t(".success") }
      format.json { head :no_content }
    end
  end

  # POST /admin/settings/administrators/1/deactivate
  # POST /admin/settings/administrators/1/deactivate.json
  def deactivate
    @administrator.deactivate
    respond_to do |format|
      format.html { redirect_to %i[admin settings root], notice: t(".success") }
      format.json { head :no_content }
    end
  end

  # POST /admin/settings/administrators/1/reactivate
  # POST /admin/settings/administrators/1/reactivate.json
  def reactivate
    @administrator.reactivate
    respond_to do |format|
      format.html { redirect_to %i[admin settings root], notice: t(".success") }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /admin/settings/administrators/1/resend_confirmation_instructions
  # PATCH/PUT /admin/settings/administrators/1/resend_confirmation_instructions.json
  def resend_confirmation_instructions
    respond_to do |format|
      @administrator.send_confirmation_instructions
      format.html { redirect_to %i[admin settings root], notice: t(".success") }
      format.json do
        render :resend_confirmation_instructions,
          status: :ok,
          location: @administrator
      end
    end
  end

  # POST /admin/settings/administrators/1/transfer
  def transfer
    if @administrator.transfer(params[:transfer_email])
      redirect_to %i[admin settings root], notice: t(".success")
    else
      redirect_to edit_admin_settings_administrator_path(@administrator), notice: t(".error")
    end
  end

  def destroy = @administrator.destroy!

  private

  def set_administrators
    @permitted_params = permitted_params
    @q = Administrator.includes(:inviter).ransack(permitted_params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @administrators_active = @q.result.active.includes(:employer, :job_offer_actors)
    @administrators_inactive = @q.result.inactive.includes(:employer)
  end

  def administrator_params
    params
      .require(:administrator)
      .permit(:title, :first_name, :last_name, :email, :employer_id, :ace, :ate, roles: [], employer_ids: [])
  end

  def set_role_and_employer
    @administrator.employer = current_administrator.employer unless current_administrator.admin?
  end

  def permitted_params
    params.permit(
      q: [:employer_id_eq, :first_name_or_last_name_or_email_cont, :role_eq, :s]
    )
  end
end
