# frozen_string_literal: true

class Admin::Settings::CmgsController < Admin::Settings::InheritedResourcesController
  protected

  def permitted_fields
    %i[email]
  end
end
