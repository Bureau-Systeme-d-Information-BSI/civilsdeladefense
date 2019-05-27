# frozen_string_literal: true

class Admin::Settings::EmailTemplatesController < Admin::Settings::InheritedResourcesController
  protected

  def permitted_fields
    %i[title subject body]
  end
end
