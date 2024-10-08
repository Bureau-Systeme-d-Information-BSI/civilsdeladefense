require "rails_helper"

RSpec.describe "Account::Profiles" do
  let(:user) { create(:confirmed_user) }

  before { sign_in user }

  describe "GET /espace-candidat/mon-profile/edit" do
    subject(:edit_request) { get edit_account_profiles_path }

    before { edit_request }

    it { expect(response).to be_successful }

    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH /espace-candidat/mon-profile" do
    subject(:update_request) { patch account_profiles_path, params: }

    let(:params) do
      {
        profile: {
          availability_range_id:,
          study_level_id:,
          experience_level_id:,
          has_corporate_experience: true,
          resume: fixture_file_upload("document.pdf", "application/pdf"),
          category_experience_levels_attributes: {
            "0": {
              category_id:,
              experience_level_id:
            }
          }
        }
      }
    end
    let(:availability_range_id) { AvailabilityRange.first.id }
    let(:study_level_id) { create(:study_level).id }
    let(:experience_level_id) { create(:experience_level).id }
    let(:category_id) { create(:category).id }

    before { user.update!(profile: create(:profile, profileable: user)) }

    it { expect { update_request }.not_to change { user.reload.profile } }

    describe "profile" do
      let(:profile) { user.profile }

      before { update_request }

      it { expect(profile.availability_range_id).to eq(availability_range_id) }

      it { expect(profile.study_level_id).to eq(study_level_id) }

      it { expect(profile.experience_level_id).to eq(experience_level_id) }

      it { expect(profile.has_corporate_experience).to be(true) }

      it { expect(profile.reload.category_experience_levels.count).to eq(1) }

      it { expect(profile.category_experience_levels.first.category_id).to eq(category_id) }

      it { expect(profile.category_experience_levels.first.experience_level_id).to eq(experience_level_id) }

      it { expect(profile.resume).to be_present }
    end

    describe "response" do
      before { update_request }

      it { expect(response).to redirect_to(edit_account_profiles_path) }
    end
  end
end
