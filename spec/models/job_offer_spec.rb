# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobOffer do
  let(:organization) { job_offer.organization }
  let(:employer) { create(:employer) }
  let(:job_offer) { create(:job_offer) }

  %i[employer grand_employer supervisor_employer brh].each do |role|
    it { is_expected.to have_many(:"job_offer_#{role}_actors").inverse_of(:job_offer) }
  end

  describe "scopes" do
    describe ".bookmarked" do
      subject { described_class.bookmarked(user) }

      let(:user) { create(:user) }
      let(:matching_job_offer) { create(:bookmark, user:).job_offer }
      let(:non_matching_job_offer) { create(:job_offer) }

      it { is_expected.to include(matching_job_offer) }

      it { is_expected.not_to include(non_matching_job_offer) }
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:archiving_reason).optional(true) }

    it { is_expected.to belong_to(:category).optional(true) }

    it { is_expected.to belong_to(:level) }

    it { is_expected.to have_many(:bookmarks).dependent(:destroy) }

    it { is_expected.to have_many(:job_offer_actors).dependent(:destroy) }

    it { is_expected.to have_many(:benefit_job_offers).dependent(:destroy) }

    it { is_expected.to have_many(:benefits).through(:benefit_job_offers) }

    it { is_expected.to have_many(:drawback_job_offers).dependent(:destroy) }

    it { is_expected.to have_many(:drawbacks).through(:drawback_job_offers) }
  end

  describe "delegations" do
    it { is_expected.to delegate_method(:name).to(:contract_type).with_prefix(true).with_arguments(allow_nil: true) }
  end

  describe "#contract_duration_name" do
    subject { job_offer.contract_duration_name }

    context "when contract_type is nil" do
      before { allow(job_offer).to receive(:contract_type).and_return(nil) }

      it { is_expected.to be_nil }
    end

    context "when contract_type duration is false" do
      before { job_offer.contract_type.update!(duration: false) }

      it { is_expected.to be_nil }
    end

    context "when contract_duration is nil" do
      before { job_offer.update!(contract_duration: nil) }

      it { is_expected.to be_nil }
    end

    context "when otherwise" do
      before { job_offer.update!(contract_type: create(:contract_type, duration: true), contract_duration:) }

      let(:contract_duration) { create(:contract_duration) }

      it { is_expected.to eq contract_duration.name }
    end
  end

  describe ".spontaneous?" do
    subject { described_class.spontaneous? }

    context "when there is at least one published spontaneous job offer" do
      before { create(:job_offer, spontaneous: true, state: :published) }

      it { is_expected.to be true }
    end

    context "when there is no spontaneous job offer" do
      before { create(:job_offer, spontaneous: false, state: :published) }

      it { is_expected.to be false }
    end

    context "when there is a spontaneous job offer but it's not published" do
      before { create(:job_offer, spontaneous: true, state: :draft) }

      it { is_expected.to be false }
    end
  end

  describe ".spontaneous_job_offer" do
    subject { described_class.spontaneous_job_offer }

    context "when there is at least one published spontaneous job offer" do
      let!(:job_offer) { create(:job_offer, spontaneous: true, state: :published) }

      it { is_expected.to eq(job_offer) }
    end

    context "when there is no spontaneous job offer" do
      before { create(:job_offer, spontaneous: false, state: :published) }

      it { is_expected.to be_nil }
    end

    context "when there is a spontaneous job offer but it's not published" do
      before { create(:job_offer, spontaneous: true, state: :draft) }

      it { is_expected.to be_nil }
    end
  end

  describe "contract_duration" do
    let(:job_offer) do
      build(:job_offer, contract_type: contract_type, contract_duration: contract_duration)
    end

    context "when contrat_type duration = true" do
      let(:contract_type) { create(:contract_type, duration: true) }

      context "with contract_duration" do
        let(:contract_duration) { create(:contract_duration) }

        it "is valid" do
          expect(job_offer).to be_valid
        end
      end

      context "without contract_duration" do
        let(:contract_duration) { nil }

        it "is invalid" do
          expect(job_offer).not_to be_valid
        end
      end
    end

    context "when contrat_type duration = false" do
      let(:contract_type) { create(:contract_type, duration: false) }

      context "with contract_duration" do
        let(:contract_duration) { create(:contract_duration) }

        it "is invalid" do
          expect(job_offer).not_to be_valid
        end
      end

      context "without contract_duration" do
        let(:contract_duration) { nil }

        it "is valid" do
          expect(job_offer).to be_valid
        end
      end
    end
  end

  describe "states" do
    subject(:job_offer) { described_class.new }

    it { expect(job_offer).to transition_from(:draft).to(:published).on_event(:publish) }
    it { expect(job_offer).to transition_from(:published).to(:draft).on_event(:draftize) }
    it { expect(job_offer).to transition_from(:draft).to(:archived).on_event(:archive) }
    it { expect(job_offer).to transition_from(:published).to(:archived).on_event(:archive) }
    it { expect(job_offer).to transition_from(:suspended).to(:archived).on_event(:archive) }
    it { expect(job_offer).to transition_from(:published).to(:suspended).on_event(:suspend) }
    it { expect(job_offer).to transition_from(:suspended).to(:suspended).on_event(:suspend) }
    it { expect(job_offer).to transition_from(:suspended).to(:published).on_event(:unsuspend) }
    it { expect(job_offer).to transition_from(:archived).to(:draft).on_event(:unarchive) }
  end

  describe "state_date" do
    it "sets published_at date when state is published" do
      expect(job_offer.state).to eq("draft")
      expect(job_offer.published_at).to be_nil
      job_offer.publish!
      expect(job_offer.state).to eq("published")
      expect(job_offer.published_at).not_to be_nil
    end

    it "sets archived_at date when state is archived" do
      expect(job_offer.state).to eq("draft")
      expect(job_offer.archived_at).to be_nil
      job_offer.publish!
      job_offer.archive!
      job_offer.reload
      expect(job_offer.state).to eq("archived")
      expect(job_offer.archived_at).not_to be_nil
    end

    it "sets suspended_at date when state is suspended" do
      expect(job_offer.state).to eq("draft")
      expect(job_offer.suspended_at).to be_nil
      job_offer.publish!
      job_offer.suspend!
      job_offer.reload
      expect(job_offer.state).to eq("suspended")
      expect(job_offer.suspended_at).not_to be_nil
    end
  end

  it "prevents publishing according to organization config" do
    organization.update(days_before_publishing: 1)

    expect { job_offer.publish! }.to raise_error(AASM::InvalidTransition)
  end

  it "allows publishing according to organization config (when days before publishing is nil)" do
    organization.update(days_before_publishing: nil)

    expect { job_offer.publish! }.not_to raise_error
  end

  it "allows publishing according to organization config (when days before publishing is 0)" do
    organization.update(days_before_publishing: 0)

    expect { job_offer.publish! }.not_to raise_error
  end

  it "computes publishing_possible_at" do
    organization.update(days_before_publishing: 2)

    expect(job_offer.publishing_possible_at).to eq(job_offer.created_at + 2.working.days)
  end

  it "correctlies find current most advanced job application state" do
    job_applications = create_list(:job_application, 10, job_offer: job_offer)
    expect(job_offer.current_most_advanced_job_applications_state).to eq(0)
    last_state_name, last_state_enum = JobApplication.states.to_a.last
    job_applications.last.send(:"#{last_state_name}!")
    expect(job_offer.current_most_advanced_job_applications_state).to eq(last_state_enum)
  end

  it "is visible by owner" do
    owner = create(:administrator, role: "employer", employer: employer)
    job_offer = create(:job_offer, owner: owner)
    ability = Ability.new(owner)
    expect(ability.can?(:manage, job_offer)).to be true
  end

  it "is visible by actors" do
    brh = create(:administrator, role: nil, employer: employer)
    other_admin = create(:administrator, role: nil, employer: employer)

    create(:job_offer_actor, role: "brh", administrator: brh, job_offer: job_offer)

    ability = Ability.new(brh)
    expect(ability.can?(:read, job_offer)).to be true

    ability = Ability.new(other_admin)
    expect(ability.can?(:manage, job_offer)).to be false
    expect(ability.can?(:read, job_offer)).to be false
  end

  it "sets identifier correctly even when employer has been changed" do
    job_offer1 = create(:job_offer)
    expect(job_offer1.identifier).to eq "#{job_offer1.employer.code}1"

    job_offer2 = create(:job_offer, employer: job_offer1.employer)
    expect(job_offer2.identifier).to eq "#{job_offer1.employer.code}2"

    job_offer3 = create(:job_offer)
    expect(job_offer3.identifier).to eq "#{job_offer3.employer.code}1"

    job_offer3.employer = job_offer1.employer
    job_offer3.save
    expect(job_offer3.identifier).to eq "#{job_offer1.employer.code}3"
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:csp_value) }

    it { is_expected.to validate_presence_of(:csp_date) }

    it { is_expected.to validate_presence_of(:mobilia_value) }

    it { is_expected.to validate_presence_of(:mobilia_date) }

    describe "title" do
      it "is not valid with ( in title and no F/H at the end" do
        expect(build(:job_offer, title: "(")).not_to be_valid
      end

      it "is not valid with ( in title and F/H at the end" do
        expect(build(:job_offer, title: "( F/H")).not_to be_valid
      end

      it "is valid without ( in title and with F/H at the end" do
        expect(build(:job_offer, title: "no parenthesis F/H")).to be_valid
      end
    end

    describe "description" do
      let(:job_offer) { build(:job_offer, state: :published, description: description) }

      context "with description more than 2000 chars" do
        let(:description) { "desc" * 2000 }

        it "is not valid" do
          expect(job_offer).not_to be_valid
        end
      end

      context "with description less than 2000 chars with lot of HTML" do
        let(:description) { "<p>d</p>" * 1999 }

        it "is valid" do
          expect(job_offer).to be_valid
        end
      end

      context "with description less than 2000 chars" do
        let(:description) { "desc" }

        it "is valid" do
          expect(job_offer).to be_valid
        end
      end
    end

    describe "application_deadline" do
      let(:job_offer) { build(:job_offer, state: :published, application_deadline:) }

      context "with application_deadline is in the past" do
        let(:application_deadline) { 1.day.ago }

        it { expect(job_offer).not_to be_valid }
      end

      context "with application_deadline is today" do
        let(:application_deadline) { Date.current }

        it { expect(job_offer).not_to be_valid }
      end

      context "with application_deadline is in the future" do
        let(:application_deadline) { 1.day.from_now }

        it { expect(job_offer).to be_valid }
      end

      context "with application_deadline is nil" do
        let(:application_deadline) { nil }

        it { expect(job_offer).to be_valid }
      end
    end
  end

  describe "publishing" do
    it "requires organization_description" do
      job_offer = create(:job_offer, organization_description: nil)
      expect { job_offer.publish! }.not_to change { job_offer.reload.state }
    end
  end

  describe "unarchiving" do
    it "removes the archiving reason when it exists" do
      job_offer = create(:archived_job_offer)
      expect { job_offer.unarchive! }.to change { job_offer.reload.archiving_reason }.to(nil)
    end
  end

  describe "#bookmarked_by?" do
    subject { job_offer.bookmarked_by?(user) }

    let(:job_offer) { create(:job_offer) }

    context "when user is nil" do
      let(:user) { nil }

      it { is_expected.to be false }
    end

    context "when user is not nil" do
      let(:user) { create(:user) }

      context "when user has bookmarked the job offer" do
        before { create(:bookmark, user: user, job_offer: job_offer) }

        it { is_expected.to be true }
      end

      context "when user has not bookmarked the job offer" do
        it { is_expected.to be false }
      end
    end
  end
end

# == Schema Information
#
# Table name: job_offers
#
#  id                                               :uuid             not null, primary key
#  accepted_job_applications_count                  :integer          default(0), not null
#  affected_job_applications_count                  :integer          default(0), not null
#  after_meeting_rejected_job_applications_count    :integer          default(0), not null
#  application_deadline                             :date
#  archived_at                                      :datetime
#  city                                             :string
#  contract_drafting_job_applications_count         :integer          default(0), not null
#  contract_feedback_waiting_job_applications_count :integer          default(0), not null
#  contract_received_job_applications_count         :integer          default(0), not null
#  contract_start_on                                :date             not null
#  country_code                                     :string
#  county                                           :string
#  county_code                                      :integer
#  csp_date                                         :date
#  csp_value                                        :string
#  description                                      :text
#  draft_at                                         :datetime
#  estimate_annual_salary_gross                     :string
#  estimate_monthly_salary_net                      :string
#  featured                                         :boolean          default(FALSE)
#  identifier                                       :string
#  initial_job_applications_count                   :integer          default(0), not null
#  is_remote_possible                               :boolean
#  job_applications_count                           :integer          default(0), not null
#  location                                         :string
#  mobilia_date                                     :date
#  mobilia_value                                    :string
#  most_advanced_job_applications_state             :integer          default("start")
#  notifications_count                              :integer          default(0)
#  option_photo                                     :integer
#  organization_description                         :text
#  phone_meeting_job_applications_count             :integer          default(0), not null
#  phone_meeting_rejected_job_applications_count    :integer          default(0), not null
#  postcode                                         :string
#  published_at                                     :datetime
#  recruitment_process                              :text
#  region                                           :string
#  rejected_job_applications_count                  :integer          default(0), not null
#  required_profile                                 :text
#  slug                                             :string           not null
#  spontaneous                                      :boolean          default(FALSE)
#  state                                            :integer
#  suspended_at                                     :datetime
#  title                                            :string
#  to_be_met_job_applications_count                 :integer          default(0), not null
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  archiving_reason_id                              :uuid
#  bop_id                                           :uuid
#  category_id                                      :uuid
#  contract_duration_id                             :uuid
#  contract_type_id                                 :uuid
#  employer_id                                      :uuid
#  experience_level_id                              :uuid
#  level_id                                         :uuid
#  organization_id                                  :uuid
#  owner_id                                         :uuid
#  professional_category_id                         :uuid
#  sector_id                                        :uuid
#  sequential_id                                    :integer
#  study_level_id                                   :uuid
#
# Indexes
#
#  index_job_offers_on_archiving_reason_id       (archiving_reason_id)
#  index_job_offers_on_bop_id                    (bop_id)
#  index_job_offers_on_category_id               (category_id)
#  index_job_offers_on_contract_duration_id      (contract_duration_id)
#  index_job_offers_on_contract_type_id          (contract_type_id)
#  index_job_offers_on_employer_id               (employer_id)
#  index_job_offers_on_experience_level_id       (experience_level_id)
#  index_job_offers_on_identifier                (identifier) UNIQUE
#  index_job_offers_on_level_id                  (level_id)
#  index_job_offers_on_organization_id           (organization_id)
#  index_job_offers_on_owner_id                  (owner_id)
#  index_job_offers_on_professional_category_id  (professional_category_id)
#  index_job_offers_on_sector_id                 (sector_id)
#  index_job_offers_on_slug                      (slug) UNIQUE
#  index_job_offers_on_state                     (state)
#  index_job_offers_on_study_level_id            (study_level_id)
#
# Foreign Keys
#
#  fk_rails_0f37831741  (level_id => levels.id)
#  fk_rails_1d6fc1ac2d  (professional_category_id => professional_categories.id)
#  fk_rails_1db997256c  (experience_level_id => experience_levels.id)
#  fk_rails_2e21ee1517  (study_level_id => study_levels.id)
#  fk_rails_39bc76a4ec  (contract_type_id => contract_types.id)
#  fk_rails_3afb853ff8  (bop_id => bops.id)
#  fk_rails_4cbd429856  (archiving_reason_id => archiving_reasons.id)
#  fk_rails_578c30296c  (category_id => categories.id)
#  fk_rails_5aaea6c8db  (employer_id => employers.id)
#  fk_rails_6cf1ead2e5  (owner_id => administrators.id)
#  fk_rails_ee7a101e4f  (sector_id => sectors.id)
#
