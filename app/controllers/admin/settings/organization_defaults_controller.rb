# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class Admin::Settings::OrganizationDefaultsController < Admin::Settings::InheritedResourcesController
  protected

  def begin_of_association_chain
    current_organization
  end

  def permitted_fields
    %i[kind value]
  end
end
# rubocop:enable Layout/LineLength
