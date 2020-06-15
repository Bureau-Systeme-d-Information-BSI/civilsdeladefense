# frozen_string_literal: true

class Admin::Settings::OrganizationsController < Admin::Settings::BaseController
  before_action :set_organization

  def edit
    @organization_form_general = @organization
    @organization_form_display = @organization
    @organization_form_security = @organization
  end

  def update_general
    if @organization.update(general_permitted_params)
      redirect_to action: :edit, notice: t('.success')
    else
      @organization_form_general = @organization
      @organization_form_display = @organization_cloned
      @organization_form_security = @organization_cloned

      render action: :edit
    end
  end

  def update_display
    if @organization.update(display_permitted_params)
      redirect_to action: :edit, notice: t('.success')
    else
      @organization_form_general = @organization_cloned
      @organization_form_display = @organization
      @organization_form_security = @organization_cloned

      render action: :edit
    end
  end

  def update_security
    if @organization.update(security_permitted_params)
      redirect_to action: :edit, notice: t('.success')
    else
      @organization_form_general = @organization_cloned
      @organization_form_display = @organization_cloned
      @organization_form_security = @organization

      render action: :edit
    end
  end

  private

  def set_organization
    @organization = current_organization
    @organization_cloned = current_organization.clone
  end

  protected

  def general_permitted_params
    permitted_fields = %i[name name_business_owner subdomain domain privacy_policy_url
                          inbound_email_config]
    params.require(:organization).permit(permitted_fields)
  end

  def display_permitted_params
    permitted_fields = %i[logo_vertical logo_horizontal
                          logo_vertical_negative logo_horizontal_negative
                          image_background]
    params.require(:organization).permit(permitted_fields)
  end

  def security_permitted_params
    permitted_fields = %i[administrator_email_suffix]
    params.require(:organization).permit(permitted_fields)
  end
end
