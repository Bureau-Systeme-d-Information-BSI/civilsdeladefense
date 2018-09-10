class Admin::Settings::AdministratorsController < Admin::Settings::BaseController
  before_action :set_role_and_employer, only: %i(new create)
  # GET /admin/settings/administrators
  # GET /admin/settings/administrators.json
  def index
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
    respond_to do |format|
      if @administrator.save
        format.html { redirect_to [:admin, :settings, :root], notice: t('.success') }
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
        format.html { redirect_to [:admin, :settings, :root], notice: t('.success') }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :edit }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/settings/administrators/1
  # DELETE /admin/settings/administrators/1.json
  def destroy
    @administrator.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, :settings, :root], notice: t('.success') }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /admin/settings/administrators/1/resend_confirmation_instructions
  # PATCH/PUT /admin/settings/administrators/1/resend_confirmation_instructions.json
  def resend_confirmation_instructions
    respond_to do |format|
      @administrator.send_confirmation_instructions
      format.html { redirect_to [:admin, :settings, :root], notice: t('.success') }
      format.json { render :resend_confirmation_instructions, status: :ok, location: @administrator }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def administrator_params
      params.require(:administrator).permit(permitted_fields)
    end

    def permitted_fields
      ary = %i(title first_name last_name email)
      ary += %i(role employer_id) if current_administrator.bant?
      ary
    end

    def set_role_and_employer
      unless current_administrator.bant?
        @administrator.role = 'employer'
        @administrator.employer = current_administrator.employer
      end
    end
end
