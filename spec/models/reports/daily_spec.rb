# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::Daily do
  describe "#sections" do
    subject(:sections) { described_class.new(administrator).sections }

    let(:administrator) { create(:administrator, roles: %w[employer_recruiter]) }
    let(:other_administrator) { create(:administrator, roles: %w[employer_recruiter]) }

    it "returns new_offers followed by every application state in order" do
      expect(sections.map(&:key)).to eq(["new_offers"] + JobApplication::ORDERED_STATES)
    end

    it "exposes count, human_state and items for each section" do
      sections.each do |section|
        expect(section).to be_a(described_class::Section)
        expect(section.count).to eq(section.items.size)
        expect(section.human_state).to be_a(String).and be_present
        expect(section.items).to all(be_a(described_class::Item))
      end
    end

    describe "new_offers section" do
      subject(:section) { sections.find { |s| s.key == "new_offers" } }

      let(:yesterday_start) { 1.day.ago.beginning_of_day }
      let!(:own_in_yesterday) do
        create(:published_job_offer, published_at: yesterday_start + 12.hours).tap { |offer| link_admin_to(offer) }
      end

      before do
        create(:published_job_offer, published_at: yesterday_start - 1.second).tap do |offer|
          link_admin_to(offer)
        end # before yesterday
        create(:published_job_offer, published_at: Date.current.beginning_of_day).tap do |offer|
          link_admin_to(offer)
        end # today
        create(:job_offer, state: :draft).tap do |offer|
          link_admin_to(offer)
        end # draft
        create(:published_job_offer, published_at: yesterday_start + 12.hours).tap do |offer|
          link_admin_to(offer, admin: other_administrator)
        end # other admin
      end

      it "lists only offers published yesterday the administrator is an actor on" do
        expect(section.items.map(&:title)).to contain_exactly(own_in_yesterday.full_title)
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

    JobApplication::ORDERED_STATES.each do |state|
      describe "#{state} section" do
        subject(:section) { sections.find { |s| s.key == state } }

        let(:job_offer) { create(:published_job_offer).tap { |offer| link_admin_to(offer) } }

        before { create(:job_application, job_offer:, state:) }

        it "lists offers having applications in state :#{state}" do
          expect(section.items.map(&:title)).to contain_exactly(job_offer.full_title)
        end

        it "uses the back-office link for each item" do
          expect(section.items.first.link).to include("/admin/")
        end
      end
    end

    describe "application sections filtering" do
      let(:job_offer) { create(:published_job_offer).tap { |offer| link_admin_to(offer) } }
      let(:other_offer) { create(:published_job_offer).tap { |offer| link_admin_to(offer, admin: other_administrator) } }

      it "excludes rejected applications" do
        create(:job_application, :rejected, job_offer: job_offer, state: :phone_meeting)
        section = sections.find { |s| s.key == "phone_meeting" }
        expect(section.count).to eq(0)
        expect(section.items).to be_empty
      end

      it "excludes applications on offers the administrator is not an actor on" do
        create(:job_application, job_offer: other_offer, state: :phone_meeting)
        section = sections.find { |s| s.key == "phone_meeting" }
        expect(section.count).to eq(0)
      end

      it "lists an offer only once even when several applications share the same state" do
        create_list(:job_application, 3, job_offer:, state: :phone_meeting)
        section = sections.find { |s| s.key == "phone_meeting" }
        expect(section.count).to eq(1)
        expect(section.items.size).to eq(1)
      end

      it "does not surface an offer in states where none of its applications match" do
        create(:job_application, job_offer:, state: :phone_meeting)
        section = sections.find { |s| s.key == "to_be_met" }
        expect(section.count).to eq(0)
      end
    end
  end

  private

  def link_admin_to(job_offer, admin: administrator)
    create(:job_offer_actor, job_offer: job_offer, administrator: admin, role: :employer)
  end
end
