# frozen_string_literal: true

class Admin::Settings::OrganizationsController < Admin::Settings::InheritedResourcesController
  defaults singleton: true

  before_action :set_organization

  def edit
    key = "admin.#{resource_class.to_s.tableize}.edit.success"
    edit!(notice: t(key))
  end

  private

  def set_organization
    @organization = current_organization
  end

  protected

  def permitted_fields
    %i[name name_business_owner administrator_email_suffix subdomain domain
       logo_vertical logo_horizontal
       logo_vertical_negative logo_horizontal_negative
       image_background]
  end
end
