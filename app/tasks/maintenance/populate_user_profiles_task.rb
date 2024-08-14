# frozen_string_literal: true

module Maintenance
  class PopulateUserProfilesTask < MaintenanceTasks::Task
    def collection = User.where.missing(:profile)

    def process(element) = create_user_profile(element)

    delegate :count, to: :collection

    private

    def create_user_profile(user)
      return if user.job_applications.empty?
      return if user.job_applications.first.profile.blank?

      user.profile = user.job_applications.first.profile.dup
      user.profile.profileable = user
      user.save(validate: false)
    end
  end
end
