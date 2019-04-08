class Admin::Settings::JobApplicationFileTypesController < Admin::Settings::InheritedResourcesController

  protected

    def permitted_fields
      %i(name description kind content from_state by_default)
    end
end
