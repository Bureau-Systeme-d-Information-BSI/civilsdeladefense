class Account::ProfilesController < Account::BaseController
  before_action :find_profile

  def edit
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
      profile_foreign_languages_attributes: %i[foreign_language_id foreign_language_level_id]
    )
  end
end
