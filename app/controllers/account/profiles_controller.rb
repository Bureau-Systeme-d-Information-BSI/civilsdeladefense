class Account::ProfilesController < Account::BaseController
  before_action :find_profile

  def edit
  end

  def update
    @profile.profileable.departments = departments
    @profile.profile_foreign_languages = []
    @profile.assign_attributes(profile_params.merge(profileable: current_user))
    if @profile.save
      redirect_to edit_account_profiles_path, notice: t(".success")
    else
      render :edit
    end
  end

  private

  def find_profile = @profile = current_user.profile.presence || current_user.build_profile(profileable: current_user)

  def profile_params
    params
      .require(:profile)
      .permit(
        :availability_range_id,
        :study_level_id,
        profileable_attributes: {department_users_attributes: [:department_id]},
        profile_foreign_languages_attributes: %i[foreign_language_id foreign_language_level_id]
      )
      .except(:profileable_attributes)
  end

  def departments
    return [] if department_params.blank?

    department_params.to_unsafe_h.except("index").map { |_, val| val }.pluck(:department_id).map { Department.find(_1) }
  end

  def department_params = params.dig(:profile, :profileable_attributes, :department_users_attributes)
end
