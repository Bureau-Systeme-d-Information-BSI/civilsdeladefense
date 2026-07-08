# frozen_string_literal: true

module Admin::Settings::PositionChangeable
  extend ActiveSupport::Concern

  # Explicit allowlist of models that support position changes.
  # Prevents arbitrary class loading via constantize on path parameters.
  PERMITTED_MODELS = %w[
    ArchivingReason AvailabilityRange Benefit Bop Category Cmg ContractDuration
    ContractType Drawback EmailTemplate Employer ExperienceLevel ForeignLanguage
    ForeignLanguageLevel FrequentlyAskedQuestion JobApplicationFileType JobOfferTerm
    Level Page ProfessionalCategory RejectionReason SalaryRange Sector StudyLevel
    UserMenuLink
  ].freeze

  included do
    skip_load_and_authorize_resource
    before_action :load_item
  end

  private

  def load_item
    parent_key = request.path_parameters.keys.find { |k| k.to_s.end_with?("_id") }
    model_name = parent_key.to_s.delete_suffix("_id").classify
    raise ActionController::RoutingError, "Not permitted" unless PERMITTED_MODELS.include?(model_name)

    @item = model_name.constantize.find(request.path_parameters[parent_key])
    authorize! :update, @item
  end

  def redirect_to_index
    redirect_to(controller: "admin/settings/#{@item.class.to_s.tableize}", action: :index)
  end
end
