# frozen_string_literal: true

class Admin::Settings::JobApplicationFileTypesController < Admin::Settings::InheritedResourcesController
  # rubocop:enable Layout/LineLength

  protected

  def permitted_fields
    %i[name description kind content from_state to_state required required_from_state required_to_state notification]
  end
end
