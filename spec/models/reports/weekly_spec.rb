# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::Weekly do
  describe "#sections" do
    subject(:sections) { described_class.new(administrator).sections }

    let(:administrator) { create(:administrator, roles: %w[employment_authority]) }
    let(:other_administrator) { create(:administrator, roles: %w[employment_authority]) }

    context "when the administrator has neither new offer nor open application" do
      it { is_expected.to be_empty }
    end

    context "when the administrator has a new offer and one application in every state" do
      before do
        create(:published_job_offer, published_at: 1.week.ago.beginning_of_week + 1.day).tap { |offer| link_admin_to(offer) }
        JobApplication.states.keys.each do |state|
          job_offer = create(:published_job_offer).tap { |offer| link_admin_to(offer) }
          create(:job_application, job_offer:, state:, dar: true)
        end
      end

      it "returns new_offers followed by every reported application state in order" do
        expect(sections.map(&:key)).to eq(["new_offers"] + described_class::STATES)
      end

      it "exposes count, human_state and items for each section" do
        sections.each do |section|
          expect(section).to be_a(described_class::Section)
          expect(section.count).to eq(section.items.size)
          expect(section.human_state).to be_a(String).and be_present
          expect(section.items).to all(be_a(described_class::Item))
        end
      end
    end

    describe "new_offers section" do
      subject(:section) { sections.find { |s| s.key == "new_offers" } }

      let(:last_week_start) { 1.week.ago.beginning_of_week }
      let!(:own_in_last_week) do
        create(:published_job_offer, published_at: last_week_start + 1.day).tap { |offer| link_admin_to(offer) }
      end

      before do
        create(:published_job_offer, published_at: last_week_start - 1.second).tap do |offer|
          link_admin_to(offer)
        end # before last week
        create(:published_job_offer, published_at: Date.current.beginning_of_week).tap do |offer|
          link_admin_to(offer)
        end # this week
        create(:job_offer, state: :draft).tap do |offer|
          link_admin_to(offer)
        end # draft
        create(:published_job_offer, published_at: last_week_start + 1.day).tap do |offer|
          link_admin_to(offer, admin: other_administrator)
        end # other admin
      end

      it "lists only offers published during last week the administrator is an actor on" do
        expect(section.items.map(&:title)).to contain_exactly(own_in_last_week.full_title)
      end

      it "reports the matching count" do
        expect(section.count).to eq(1)
      end

      it "builds a front-office link for each item" do
        link = section.items.first.link
        expect(link).to include("/offresdemploi/")
        expect(link).not_to include("/admin/")
      end
    end

    described_class::STATES.each do |state|
      describe "#{state} section" do
        subject(:section) { sections.find { |s| s.key == state } }

        let(:job_offer) { create(:published_job_offer).tap { |offer| link_admin_to(offer) } }

        before { create(:job_application, job_offer:, state:, dar: true) }

        it "lists offers having applications in state :#{state}" do
          expect(section.items.map(&:title)).to contain_exactly(job_offer.full_title)
        end

        it "uses the back-office link for each item" do
          expect(section.items.first.link).to include("/admin/")
        end
      end
    end

    describe "application sections filtering" do
      let(:job_offer) { create(:published_job_offer, positions_count: 10).tap { |offer| link_admin_to(offer) } }
      let(:other_offer) { create(:published_job_offer, positions_count: 10).tap { |offer| link_admin_to(offer, admin: other_administrator) } }

      it "excludes rejected applications" do
        create(:job_application, :rejected, job_offer: job_offer, state: :accepted)
        expect(sections.find { |s| s.key == "accepted" }).to be_nil
      end

      it "excludes applications on offers the administrator is not an actor on" do
        create(:job_application, job_offer: other_offer, state: :accepted)
        expect(sections.find { |s| s.key == "accepted" }).to be_nil
      end

      it "lists an offer only once even when several applications share the same state" do
        create_list(:job_application, 3, job_offer:, state: :accepted)
        section = sections.find { |s| s.key == "accepted" }
        expect(section.count).to eq(1)
        expect(section.items.size).to eq(1)
      end

      it "does not surface an offer in states where none of its applications match" do
        create(:job_application, job_offer:, state: :accepted)
        expect(sections.find { |s| s.key == "contract_drafting" }).to be_nil
      end

      it "ignores states not listed in the report" do
        create(:job_application, job_offer:, state: :phone_meeting)
        expect(sections.find { |s| s.key == "phone_meeting" }).to be_nil
      end
    end
  end

  private

  def link_admin_to(job_offer, admin: administrator)
    create(:job_offer_actor, job_offer: job_offer, administrator: admin, role: :employer)
  end
end
