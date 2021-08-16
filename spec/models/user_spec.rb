# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:confirmed_user) }
  let(:another_user) { create(:confirmed_user) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "can be suspended" do
    text = "Bad guy"
    expect(user.suspended_at).to be_nil
    expect(user.active_for_authentication?).to be_truthy
    user.suspend!(text)
    expect(user.suspended?).to be_truthy
    expect(user.suspended_at).to_not be_nil
    expect(user.suspension_reason).to eq(text)
    expect(user.active_for_authentication?).to be_falsey
  end

  it "cannot be destroyed when suspended" do
    user.unsuspend!
    expect { user.destroy }.to change(User, :count).by(-1)

    another_user.unsuspend!
    another_user.suspend!("Bad guy")
    expect(another_user.suspended?).to be_truthy
    expect { another_user.destroy }.to change(User, :count).by(0)
  end

  it "should purge associated objects when destroyed" do
    job_application_file_type = create(:job_application_file_type)

    job_application = create(:job_application, user: user)
    job_application_file = build(:job_application_file,
      job_application_file_type: job_application_file_type)
    job_application.job_application_files << job_application_file

    count = job_application.job_application_files.count
    expect(count).to eq(1)

    count_before = JobApplicationFile.count
    expect(count_before).to eq(1)

    user.destroy
    count_after = JobApplicationFile.count
    expect(count_after).to eq(count_before - 1)
  end

  it "should correctly answer if already applied or not" do
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

  it "should correctly count active job applications" do
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
    let(:user) { FactoryBot.build(:user) }

    context "with omniauth_informations" do
      before do
        FactoryBot.create_list(:omniauth_information, 10, user: user)
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
        expect(user).to be_invalid
      end
    end
  end

  it "should compute notice period difference in days" do
    ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"] = "100"
    ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"] = "20"
    expect(User.notice_period_target_date.to_date).to eq(80.days.ago.to_date)
  end

  describe "automatic deletion" do
    before do
      ENV["DAYS_INACTIVITY_PERIOD_BEFORE_DELETION"] = "100"
      ENV["DAYS_NOTICE_PERIOD_BEFORE_DELETION"] = "20"
      user.reload
      User.destroy_when_too_old
    end

    context "connected long time ago" do
      let!(:user) { create(:user, last_sign_in_at: 81.days.ago) }

      it "marked" do
        expect(user.reload.marked_for_deletion_on).to eq(Time.zone.now.to_date)
      end
    end

    context "marked but has not connected since" do
      let!(:user) do
        user = create(:user, last_sign_in_at: 101.days.ago)
        user.update_column(:marked_for_deletion_on, 21.days.ago)
        user
      end

      it "delete" do
        expect(User.exists?(user.id)).to eq(false)
      end
    end

    context "marked but has connected since" do
      let!(:user) { create(:user, marked_for_deletion_on: 21.days.ago, last_sign_in_at: Time.zone.now) }

      it "doesn't delete" do
        expect(User.exists?(user.id)).to eq(true)
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
