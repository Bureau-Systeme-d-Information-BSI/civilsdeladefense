# frozen_string_literal: true

class Admin::Settings::UserMenuLinksController < Admin::Settings::InheritedResourcesController
  def permitted_fields
    %i[name url]
  end
end
