# frozen_string_literal: true

class Admin::InheritedResourcesController < Admin::BaseController
  respond_to :html, :json

  helper_method :resource_class, :collection, :resource, :collection_url

  def create
    key = "admin.#{resource_class.to_s.tableize}.create.success"
    resource.administrator = current_administrator if resource.has_attribute?(:administrator_id)
    create!(notice: t(key))
  end

  def update
    key = "admin.#{resource_class.to_s.tableize}.update.success"
    update!(notice: t(key))
  end

  def destroy
    key = "admin.#{resource_class.to_s.tableize}.destroy.success"
    destroy!(notice: t(key))
  end

  protected

  def permitted_fields
    %i[name]
  end

  def permitted_params
    params.require(resource_class.to_s.tableize.singularize.to_sym).permit(permitted_fields)
  end

  alias_method :resource_params, :permitted_params

  def resource_class
    controller_name.classify.constantize
  end

  def resource
    instance_variable_get(:"@#{controller_name.singularize}")
  end

  def collection
    instance_variable_get(:"@#{controller_name}")
  end

  def collection_url
    [:admin, :"#{controller_name}"]
  end
end
