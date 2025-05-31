# frozen_string_literal: true

module Admin::SettingsHelper
  def settings_navbar_item(entry)
    return unless can?(:read, entry.to_s.singularize.classify.constantize)

    klasses = %w[list-group-item d-flex justify-content-between align-items-center]
    klasses << "active" if controller.controller_name == entry.to_s
    link_to [:admin, :settings, entry], class: klasses do
      t(".#{entry}")
    end
  end
end
