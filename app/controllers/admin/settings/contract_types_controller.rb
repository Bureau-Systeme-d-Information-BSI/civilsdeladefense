# frozen_string_literal: true

class Admin::Settings::ContractTypesController < Admin::Settings::InheritedResourcesController
  def permitted_fields
    super + %i[duration]
  end
end
