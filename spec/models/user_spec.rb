# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  let(:user) { create(:confirmed_user) }
  let(:another_user) { create(:confirmed_user) }

  describe "validations" do
    it { expect(user).to be_valid }
  end

  describe "associations" do
    it { is_expected.to have_many(:bookmarks).dependent(:destroy) }

    it { is_expected.to have_many(:job_applications).inverse_of(:user) }
  end

  it "can be suspended" do
    text = "Bad guy"
    expect(user.suspended_at).to be_nil
    expect(user).to be_active_for_authentication
    user.suspend!(text)
    expect(user).to be_suspended
    expect(user.suspended_at).not_to be_nil
    expect(user.suspension_reason).to eq(text)
    expect(user).not_to be_active_for_authentication
  end

  it "cannot be destroyed when suspended" do
    user.unsuspend!
    expect { user.destroy }.to change(described_class, :count).by(-1)

    another_user.unsuspend!
    another_user.suspend!("Bad guy")
    expect(another_user).to be_suspended
    expect { another_user.destroy }.not_to change(described_class, :count)
  end

  context "when destroyed" do
    let(:job_application) { create(:job_application, :with_job_application_file, user: user) }
    let(:job_application_file) { job_application.job_application_files.first }

    it "purges associated objects" do
      count = job_application.job_application_files.count
      expect(count).to eq(1)

      count_before = JobApplicationFile.count
      expect(count_before).to eq(1)

      user.destroy
      count_after = JobApplicationFile.count
      expect(count_after).to eq(count_before - 1)
    end

    it "recomputes notifications counter" do
      create(:email, job_application: job_application, is_unread: true)

      expect { user.destroy }.to change { job_application.reload.administrator_notifications_count }.from(1).to(0)
    end
  end

  it "correctlies answer if already applied or not" do
    job_application_file_type = create(:job_application_file_type)
    job_application = create(:job_application, user: user)
    expect(job_application).to be_valid

    create(:job_application_file,
      job_application: job_application,
      job_application_file_type: job_application_file_type)

    already_applied = user.already_applied?(job_application.job_offer)

    expect(already_applied).to be_truthy

    another_job_offer = create(:job_offer)

    another_already_applied = user.already_applied?(another_job_offer)

    expect(another_already_applied).to be_falsey
  end

  it "correctlies count active job applications" do
    job_application_file_type = create(:job_application_file_type)
    file = fixture_file_upload("document.pdf", "application/pdf")
    jaf_attrs = [
      {
        content: file,
        job_application_file_type_id: job_application_file_type.id
      }
    ]
    job_application = create(:job_application,
      user: user,
      job_application_files_attributes: jaf_attrs)

    expect(job_application).to be_valid

    job_application_file_type = create(:job_application_file_type)
    file = fixture_file_upload("document.pdf", "application/pdf")
    jaf_attrs = [
      {
        content: file,
        job_application_file_type_id: job_application_file_type.id
      }
    ]
    job_application2 = create(:job_application,
      user: user,
      job_application_files_attributes: jaf_attrs)

    expect(job_application2).to be_valid

    expect(user.job_applications_active.count).to eq(2)

    job_offer = job_application2.job_offer
    job_offer.publish!
    job_offer.archive!

    expect(user.job_applications_active.count).to eq(1)
  end

  describe "required password" do
    let(:user) { build(:user) }

    context "with omniauth_informations" do
      before do
        create_list(:omniauth_information, 10, user: user)
        user.password = ""
      end

      it "is not required" do
        expect(user).to be_valid
      end
    end

    context "without omniauth_informations" do
      before do
        user.password = ""
      end

      it "is required" do
        expect(user).not_to be_valid
      end
    end
  end

  it "computes notice period difference in days" do
    ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"] = "100"
    ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"] = "20"
    expect(described_class.notice_period_target_date.to_date).to eq(80.days.ago.to_date)
  end

  describe "automatic deletion" do
    before do
      ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"] = "100"
      ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"] = "20"
      user.reload
      described_class.destroy_when_too_old
    end

    context "when connected long time ago" do
      let!(:user) { create(:user, last_sign_in_at: 81.days.ago) }

      it "marked" do
        expect(user.reload.marked_for_deletion_on).to eq(Time.zone.now.to_date)
      end
    end

    context "when marked but has not connected since" do
      let!(:user) do
        user = create(:user, last_sign_in_at: 101.days.ago)
        user.update_column(:marked_for_deletion_on, 21.days.ago) # rubocop:disable Rails/SkipsModelValidations
        user
      end

      it "delete" do
        expect(described_class.exists?(user.id)).to be(false)
      end
    end

    context "when marked but has connected since" do
      let!(:user) { create(:user, marked_for_deletion_on: 21.days.ago, last_sign_in_at: Time.zone.now) }

      it "doesn't delete" do
        expect(described_class.exists?(user.id)).to be(true)
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                               :uuid             not null, primary key
#  confirmation_sent_at             :datetime
#  confirmation_token               :string
#  confirmed_at                     :datetime
#  current_position                 :string
#  current_sign_in_at               :datetime
#  current_sign_in_ip               :inet
#  email                            :string           default(""), not null
#  encrypted_file_transfer_in_error :boolean          default(FALSE)
#  encrypted_password               :string           default(""), not null
#  failed_attempts                  :integer          default(0), not null
#  first_name                       :string
#  gender                           :integer          default("other")
#  job_applications_count           :integer          default(0), not null
#  last_name                        :string
#  last_sign_in_at                  :datetime
#  last_sign_in_ip                  :inet
#  locked_at                        :datetime
#  marked_for_deletion_on           :date
#  phone                            :string
#  photo_content_type               :string
#  photo_file_name                  :string
#  photo_file_size                  :bigint
#  photo_is_validated               :integer          default(0)
#  photo_updated_at                 :datetime
#  receive_job_offer_mails          :boolean          default(FALSE)
#  remember_created_at              :datetime
#  reset_password_sent_at           :datetime
#  reset_password_token             :string
#  sign_in_count                    :integer          default(0), not null
#  suspended_at                     :datetime
#  suspension_reason                :string
#  unconfirmed_email                :string
#  unlock_token                     :string
#  website_url                      :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  organization_id                  :uuid
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
