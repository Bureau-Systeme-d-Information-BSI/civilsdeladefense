# frozen_string_literal: true

class Admin::Settings::PagesController < Admin::Settings::InheritedResourcesController
  def destroy
    key = "admin.#{resource_class.to_s.tableize}.destroy.success"
    begin
      destroy!(notice: t(key))
    rescue ActiveRecord::DeleteRestrictionError
      resource.reinsert_children_branch
      retry
    end
  end

  def move_higher
    resource.move_higher

    redirect_to action: :index
  end

  def move_lower
    resource.move_lower

    redirect_to action: :index
  end

  protected

  def begin_of_association_chain
    current_organization
  end

  def permitted_fields
    %i[parent_id title only_link body url og_title og_description]
  end
end
