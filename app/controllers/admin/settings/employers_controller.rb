class Admin::Settings::EmployersController < Admin::Settings::InheritedResourcesController

  protected

    def permitted_fields
      super + %i(code)
    end
end

