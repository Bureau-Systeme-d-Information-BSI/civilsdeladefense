# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class Admin::Settings::JobApplicationFileTypesController < Admin::Settings::InheritedResourcesController
  # rubocop:enable Layout/LineLength

  protected

  def permitted_fields
    %i[name description kind content from_state by_default notification spontaneous]
  end
end
