class Admin::Settings::EmployersController < Admin::Settings::InheritedResourcesController

  def index
    super do |format|
      @grand_employers = collection.select{|x| x.parent_id.blank?}
      format.html {
        render template: '/admin/settings/employers/index'
      }
    end
  end

  protected

    def permitted_fields
      super + %i(code parent_id)
    end
end

