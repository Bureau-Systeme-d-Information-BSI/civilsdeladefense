# frozen_string_literal: true

class Admin::Settings::CategoriesController < Admin::Settings::InheritedResourcesController
  protected

  def permitted_fields
    super + %i[parent_id]
  end
end
