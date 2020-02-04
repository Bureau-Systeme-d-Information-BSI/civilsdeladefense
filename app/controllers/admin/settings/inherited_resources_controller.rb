# frozen_string_literal: true

class Admin::Settings::InheritedResourcesController < Admin::Settings::BaseController
  respond_to :html, :json
  inherit_resources
  actions :all, except: %i[show]

  def create
    key = "admin.settings.#{resource_class.to_s.tableize}.create.success"
    resource.organization = current_organization if resource.has_attribute?(:organization_id)
    create!(notice: t(key))
  end

  def update
    key = "admin.settings.#{resource_class.to_s.tableize}.update.success"
    update!(notice: t(key))
  end

  def destroy
    key = "admin.settings.#{resource_class.to_s.tableize}.destroy.success"
    destroy!(notice: t(key))
  rescue ActiveRecord::InvalidForeignKey
    key = "admin.settings.#{resource_class.to_s.tableize}.destroy.failure.foreign_key_violation"
    redirect_to({ action: :index }, flash: { notice: t(key) })
  end

  def move_higher
    resource.move_higher

    redirect_to action: :index
  end

  def move_lower
    resource.move_lower

    redirect_to action: :index
  end

  def move_left
    resource.move_left

    redirect_to action: :index
  end

  def move_right
    resource.move_right

    redirect_to action: :index
  end

  protected

  def permitted_fields
    %i[name]
  end

  def permitted_params
    params.require(resource_class.to_s.tableize.singularize.to_sym).permit(permitted_fields)
  end

  alias resource_params permitted_params
end
