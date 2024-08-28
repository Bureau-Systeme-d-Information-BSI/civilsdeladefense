# frozen_string_literal: true

module Maintenance
  class PopulateUserProfilesTask < MaintenanceTasks::Task
    def collection = User.unscoped.where.missing(:profile)

    def process(element) = create_profile_for(element)

    delegate :count, to: :collection

    private

    def create_profile_for(user)
      profile = user.job_applications.first&.profile

      if profile.present?
        profile.update_columns(profileable_id: user.id, profileable_type: "User") # rubocop:disable Rails/SkipsModelValidations
      else
        user.create_profile!(gender: :other)
      end
    end
  end
end
