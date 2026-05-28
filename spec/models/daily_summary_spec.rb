# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailySummary do
  subject(:summary) { described_class.new(day: Time.zone.now) }

  let(:organization) { Organization.first }

  describe "#initialize" do
    it { expect(described_class.new.instance_variable_get(:@day)).to eq(Date.yesterday) }
  end

  describe "#all_admins" do
    subject(:all_admins) { summary.all_admins }

    before { create(:administrator) }

    it { expect(all_admins).to be_empty }
  end

  describe "#prepare" do
    subject(:prepare) { summary.prepare(organization) }

    it { expect(prepare).to be_truthy }
  end

  describe "#prepare_new_job_offers" do
    subject(:prepare_new_job_offers) { summary.prepare_new_job_offers(organization) }

    before { create(:job_offer_actor, job_offer:, administrator:, role: :employer) }

    let(:job_offer) { create(:job_offer) }
    let(:administrator) { create(:administrator) }

    it { expect { prepare_new_job_offers }.to change { summary_kinds }.from([]).to(["NewJobOffer"]) }

    context "with an offer created outside the day window" do
      let(:job_offer) { create(:job_offer, created_at: 3.days.ago) }

      it { expect { prepare_new_job_offers }.not_to(change { summary_kinds }) }
    end
  end

  describe "#prepare_published_job_offers" do
    subject(:prepare_published_job_offers) { summary.prepare_published_job_offers(organization) }

    let(:job_offer) { create(:published_job_offer, published_at: Time.zone.now) }

    before { create(:job_offer_actor, job_offer:, role: :employer) }

    it { expect { prepare_published_job_offers }.to change { summary_kinds }.from([]).to(["PublishedJobOffer"]) }

    context "with an offer published outside the day window" do
      let(:job_offer) { create(:published_job_offer, published_at: 3.days.ago) }

      it { expect { prepare_published_job_offers }.not_to(change { summary_kinds }) }
    end
  end

  describe "#add_summary_infos_for_job_offer" do
    subject(:add_summary_infos_for_job_offer) { summary.add_summary_infos_for_job_offer(job_offer, "NewJobOffer") }

    before { create(:job_offer_actor, job_offer:, role: :employer) }

    let(:job_offer) { create(:job_offer) }

    it { expect { add_summary_infos_for_job_offer }.to change(concerned_administrators, :size).by(1) }

    it "links the info to the offer edit page" do
      add_summary_infos_for_job_offer
      expect(concerned_administrators.first.summary_infos.first[:link])
        .to eq(Rails.application.routes.url_helpers.edit_admin_job_offer_url(job_offer))
    end

    it "titles the info with the offer full title" do
      add_summary_infos_for_job_offer
      expect(concerned_administrators.first.summary_infos.first[:title]).to eq(job_offer.full_title)
    end

    context "when the administrator is already concerned" do
      before { summary.add_summary_infos_for_job_offer(job_offer, "NewJobOffer") }

      it { expect { add_summary_infos_for_job_offer }.not_to change(concerned_administrators, :size) }

      it { expect { add_summary_infos_for_job_offer }.to change { concerned_administrators.first.summary_infos.size }.by(1) }
    end
  end

  describe "#prepare_new_job_applications" do
    subject(:prepare_new_job_applications) { summary.prepare_new_job_applications(organization) }

    before do
      create(:job_offer_actor, job_offer:, administrator:, role: :employer)
      create(:job_application, job_offer:)
    end

    let(:job_offer) { create(:job_offer) }
    let(:administrator) { create(:administrator) }

    it { expect { prepare_new_job_applications }.to change { summary_kinds }.from([]).to(["NewJobApplication"]) }
  end

  describe "#add_summary_infos_for_job_application" do
    let(:job_application) { create(:job_application, job_offer:) }
    let(:job_offer) { create(:job_offer) }

    context "without a new state" do
      subject(:add_summary_infos_for_job_application) { summary.add_summary_infos_for_job_application(job_application) }

      before { create(:job_offer_actor, job_offer:, role: :employer) }

      it { expect { add_summary_infos_for_job_application }.to change { summary_kinds }.from([]).to(["NewJobApplication"]) }
    end

    context "with a new state" do
      subject(:add_summary_infos_for_job_application) do
        summary.add_summary_infos_for_job_application(job_application, "accepted")
      end

      before { create(:job_offer_actor, job_offer:, role: :grand_employer) }

      it { expect { add_summary_infos_for_job_application }.to change { summary_kinds }.from([]).to(["AcceptedJobApplication"]) }

      it "titles the info with the applicant name and the offer identifier" do
        add_summary_infos_for_job_application
        expect(concerned_administrators.first.summary_infos.first[:title])
          .to eq("#{job_application.user.full_name} ##{job_offer.identifier}")
      end
    end
  end

  describe "#prepare_job_applications" do
    subject(:prepare_job_applications) { summary.prepare_job_applications(organization) }

    let(:job_application) { create(:job_application, job_offer:) }
    let(:job_offer) { create(:job_offer) }

    before do
      create(:job_offer_actor, job_offer:, role: :grand_employer)
      Audited::Audit.create!(
        auditable: job_application,
        action: "update",
        audited_changes: {"state" => ["initial", "accepted"]}
      )
    end

    it { expect { prepare_job_applications }.to change { summary_kinds }.from([]).to(["AcceptedJobApplication"]) }
  end

  describe "#send_mail" do
    subject(:send_mail) { summary.send_mail(organization) }

    before do
      create(:job_offer_actor, administrator:, role: :employer)
      summary.prepare_new_job_offers(organization)
    end

    let(:administrator) { create(:administrator) }

    it { expect { send_mail }.to change { ActionMailer::Base.deliveries.size }.by(1) }

    it "delivers to the concerned administrator" do
      send_mail
      expect(ActionMailer::Base.deliveries.last.to).to eq([administrator.email])
    end
  end

  describe "#prepare_and_send" do
    subject(:prepare_and_send) { summary.prepare_and_send }

    before { create(:job_offer_actor, role: :employer) }

    it { expect { prepare_and_send }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end

  private

  def concerned_administrators
    summary.instance_variable_get(:@concerned_administrators)
  end

  def summary_kinds
    concerned_administrators.flat_map { |concerned| concerned.summary_infos.pluck(:kind) }
  end
end
