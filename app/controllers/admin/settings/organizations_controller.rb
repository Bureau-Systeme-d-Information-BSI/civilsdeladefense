# frozen_string_literal: true

class Admin::Settings::OrganizationsController < Admin::Settings::BaseController
  before_action :set_organization

  def edit
  end

  def update
    if @organization.update(permitted_params)
      redirect_to action: :edit, notice: t('.success')
    else
      render action: :edit
    end
  end

  private

  def set_organization
    @organization = current_organization
  end

  protected

  def permitted_params
    params.require(:organization).permit(permitted_fields)
  end

  def permitted_fields
    %i[name name_business_owner administrator_email_suffix subdomain domain
       logo_vertical logo_horizontal
       logo_vertical_negative logo_horizontal_negative
       image_background]
  end
end
