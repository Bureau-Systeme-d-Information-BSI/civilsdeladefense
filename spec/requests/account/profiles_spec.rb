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
    subject(:update_request) { patch account_profiles_path, params: params }

    let(:params) { {profile: {availability_range_id: availability_range_id, study_level_id: study_level_id}} }
    let(:availability_range_id) { AvailabilityRange.first.id }
    let(:study_level_id) { create(:study_level).id }

    context "when the user has a profile" do
      before { user.update!(profile: create(:profile, profileable: user)) }

      it { expect { update_request }.not_to change { user.reload.profile } }

      describe "response" do
        before { update_request }

        it { expect(response).to redirect_to(edit_account_profiles_path) }
      end
    end

    context "when the user doesn't have a profile" do
      it { expect { update_request }.to change { user.reload.profile }.from(nil) }

      describe "response" do
        before { update_request }

        it { expect(response).to redirect_to(edit_account_profiles_path) }
      end
    end
  end
end
