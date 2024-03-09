require "rails_helper"

RSpec.describe DeactivationFlow do
  describe ".deactivate_when_too_old!" do
    subject(:deactivate) { Administrator.deactivate_when_too_old! }

    before do
      allow(Administrator).to receive_messages(
        days_inactivity_period_before_deactivation: 30,
        days_notice_period_before_deactivation: 7
      )
      allow(DeactivationMailer).to receive(:notice).and_call_original
      allow(DeactivationMailer).to receive(:period_before).and_call_original
    end

    describe "deactivating" do
      let!(:matching_1) { create(:administrator, last_sign_in_at: 40.days.ago) } # Inactive
      let!(:matching_2) { create(:administrator, last_sign_in_at: nil, created_at: 40.days.ago) } # Never signed in
      let!(:unmatching_1) { create(:administrator, last_sign_in_at: 40.days.ago) } # Not marked for deactivation
      let!(:unmatching_2) { create(:administrator, last_sign_in_at: 40.days.ago) } # Marked for deactivation (but not old enough)

      before do
        # rubocop:disable Rails/SkipsModelValidations
        # Because marked_for_deactivation_on is set to nil in a before_save callback
        matching_1.update_columns(marked_for_deactivation_on: 10.days.ago)
        matching_2.update_columns(marked_for_deactivation_on: 10.days.ago)
        unmatching_2.update_columns(marked_for_deactivation_on: 5.days.ago)
        # rubocop:enable Rails/SkipsModelValidations
      end

      describe "deleted_at attribute" do
        it { expect { deactivate }.to change { matching_1.reload.deleted_at }.from(nil) }

        it { expect { deactivate }.to change { matching_2.reload.deleted_at }.from(nil) }

        it { expect { deactivate }.not_to change { unmatching_1.reload.deleted_at } }

        it { expect { deactivate }.not_to change { unmatching_2.reload.deleted_at } }
      end

      describe "mailing" do
        before { deactivate }

        it { expect(DeactivationMailer).to have_received(:notice).with(matching_1) }

        it { expect(DeactivationMailer).to have_received(:notice).with(matching_2) }
      end
    end

    describe "marking for deactivation" do
      let!(:matching_1) { create(:administrator, last_sign_in_at: 40.days.ago) }
      let!(:matching_2) { create(:administrator, last_sign_in_at: nil, created_at: 40.days.ago) }
      let!(:unmatching_1) { create(:administrator, last_sign_in_at: 20.days.ago) }
      let!(:unmatching_2) { create(:administrator, last_sign_in_at: 40.days.ago) }

      before do
        # rubocop:disable Rails/SkipsModelValidations
        # Because marked_for_deactivation_on is set to nil in a before_save callback
        unmatching_2.update_columns(marked_for_deactivation_on: 1.day.ago)
        # rubocop:enable Rails/SkipsModelValidations
      end

      describe "marked_for_deactivation_on attribute" do
        it { expect { deactivate }.to change { matching_1.reload.marked_for_deactivation_on }.from(nil).to(Date.current) }

        it { expect { deactivate }.to change { matching_2.reload.marked_for_deactivation_on }.from(nil).to(Date.current) }

        it { expect { deactivate }.not_to change { unmatching_1.reload.marked_for_deactivation_on } }

        it { expect { deactivate }.not_to change { unmatching_2.reload.marked_for_deactivation_on } }
      end

      describe "mailing" do
        before { deactivate }

        it { expect(DeactivationMailer).to have_received(:period_before).with(matching_1) }

        it { expect(DeactivationMailer).to have_received(:period_before).with(matching_2) }
      end
    end
  end
end
