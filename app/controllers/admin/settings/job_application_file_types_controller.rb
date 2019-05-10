# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
class Admin::Settings::JobApplicationFileTypesController < Admin::Settings::InheritedResourcesController
  # rubocop:enable Metrics/LineLength

  protected

  def permitted_fields
    %i[name description kind content from_state by_default]
  end
end
