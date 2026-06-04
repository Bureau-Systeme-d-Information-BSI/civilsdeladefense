# frozen_string_literal: true

class Admin::Settings::PagesController < Admin::Settings::InheritedResourcesController
  def update
    resource.slug = nil
    super
  end

  def destroy
    key = "admin.#{resource_class.to_s.tableize}.destroy.success"
    begin
      destroy!(notice: t(key))
    rescue ActiveRecord::DeleteRestrictionError
      resource.reinsert_children_branch
      retry
    end
  end

  protected

  def begin_of_association_chain
    current_organization
  end

  def permitted_fields
    %i[parent_id title only_link body url og_title og_description]
  end
end
