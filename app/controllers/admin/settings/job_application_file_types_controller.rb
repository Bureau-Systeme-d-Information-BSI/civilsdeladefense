# frozen_string_literal: true

class Admin::Settings::JobApplicationFileTypesController < Admin::Settings::InheritedResourcesController
  # rubocop:enable Layout/LineLength

  protected

  def permitted_fields
    %i[name description kind content from_state to_state required notification]
  end
end
