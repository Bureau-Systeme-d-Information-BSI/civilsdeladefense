class Admin::Settings::InheritedResourcesController < Admin::Settings::BaseController
  respond_to :html
  inherit_resources
  actions :all, except: %i(show)

  protected

    def permitted_fields
      %i(name)
    end

    def permitted_params
      params.permit(resource_class.to_s.tableize.singularize.to_sym => permitted_fields)
    end
end
