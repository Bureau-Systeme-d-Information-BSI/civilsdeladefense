# frozen_string_literal: true

class Admin::Settings::EmployersController < Admin::Settings::InheritedResourcesController
  def index
    super do |format|
      @grand_employers = Employer.roots
      format.html do
        render template: "/admin/settings/employers/index"
      end
    end
  end

  protected

  def permitted_fields
    super + %i[code parent_id]
  end
end
