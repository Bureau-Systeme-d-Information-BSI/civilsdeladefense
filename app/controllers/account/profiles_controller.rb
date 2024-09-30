class Account::ProfilesController < Account::BaseController
  before_action :find_profile

  def edit
    @profile.build_resume unless @profile.resume
  end

  def update
    @profile.profile_foreign_languages = []
    @profile.assign_attributes(profile_params)
    if @profile.save
      redirect_to edit_account_profiles_path, notice: t(".success")
    else
      render :edit
    end
  end

  private

  def find_profile = @profile = current_user.profile.presence || current_user.build_profile

  def profile_params
    params.require(:profile).permit(
      :availability_range_id,
      :study_level_id,
      :experience_level_id,
      :has_corporate_experience,
      profile_foreign_languages_attributes: %i[foreign_language_id foreign_language_level_id],
      resume_attributes: %i[id content _destroy]
    )
  end
end
