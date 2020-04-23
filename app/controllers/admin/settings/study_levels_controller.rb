# frozen_string_literal: true

class Admin::Settings::StudyLevelsController < Admin::Settings::InheritedResourcesController
  protected

  def permitted_fields
    super + %i[official_level]
  end
end
