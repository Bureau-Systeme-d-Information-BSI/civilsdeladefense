# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReportsMailer do
  describe "daily_summary" do
    let(:organization) { Organization.first }
    let(:administrator) { create(:administrator, email: "to@example.org") }
    let(:mail) do
      data = [
        {title: "Data Scientist", link: "https://google.com", kind: "NewJobOffer"},
        {title: "Chef des Pompiers", link: "https://google.com", kind: "PublishedJobOffer"}
      ]
      described_class.daily_summary(administrator, data, organization.service_name)
    end

    it "renders the headers" do
      expect(mail.subject).to match("Rapport")
      expect(mail.subject).to match(organization.service_name)
      expect(mail.to).to eq(["to@example.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Data Scientist")
      expect(mail.body.encoded).to match(I18n.t("reports_mailer.daily_summary.new_job_offers.title"))
      expect(mail.body.encoded).to match("Chef des Pompiers")
      expect(mail.body.encoded).to match(I18n.t("reports_mailer.daily_summary.published_job_offers.title"))
    end
  end

  describe "employer_recruiter_daily_report" do
    subject(:mail) { described_class.with(administrator:).employer_recruiter_daily_report }

    let(:administrator) { create(:administrator, roles: %w[employer_recruiter]) }

    it "sets the subject with the service name" do
      expect(mail.subject).to eq(
        I18n.t(
          "reports_mailer.employer_recruiter_daily_report.subject",
          service_name: administrator.organization.service_name
        )
      )
    end

    it { expect(mail.to).to match([administrator.email]) }

    it "renders one section per state plus the new offers section" do
      headings = mail.body.encoded.scan(%r{<h3>(.*?)</h3>}).flatten
      expect(headings.size).to eq(Reports::Daily.new(administrator).sections.size)
    end

    it "renders the intro and outro" do
      body = mail.body.encoded
      expect(body).to include("Bonjour #{administrator.full_name},")
      expect(body).to include("Cordialement,")
      expect(body).to include(administrator.organization.service_name)
    end

    context "when the administrator has no activity to report" do
      it "skips delivery" do
        expect(Reports::Daily.new(administrator).sections).to be_empty
        expect(mail.perform_deliveries).to be(false)
      end
    end

    context "with an offer published yesterday the recruiter is actor on" do
      let(:job_offer) { create(:published_job_offer, published_at: 1.day.ago.beginning_of_day + 12.hours) }

      before do
        create(:job_offer_actor, job_offer:, administrator:, role: :employer)
      end

      it "lists the offer in the mail body" do
        expect(mail.body.encoded).to include(job_offer.full_title)
      end

      it "delivers the mail" do
        expect(mail.perform_deliveries).to be(true)
      end
    end
  end

  describe "employment_authority_weekly_report" do
    subject(:mail) { described_class.with(administrator:).employment_authority_weekly_report }

    let(:administrator) { create(:administrator, roles: %w[employment_authority]) }

    it "sets the subject with the service name" do
      expect(mail.subject).to eq(
        I18n.t(
          "reports_mailer.employment_authority_weekly_report.subject",
          service_name: administrator.organization.service_name
        )
      )
    end

    it { expect(mail.to).to match([administrator.email]) }

    it "renders one section per state plus the new offers section" do
      headings = mail.body.encoded.scan(%r{<h3>(.*?)</h3>}).flatten
      expect(headings.size).to eq(Reports::Weekly.new(administrator).sections.size)
    end

    it "renders the intro mentioning the employment authority role" do
      expect(mail.body.encoded).to include("Bonjour #{administrator.full_name},")
      expect(mail.body.encoded).to include("Autorité d'emploi")
    end

    it "mentions the start of last week" do
      week_starts_on = 1.week.ago.beginning_of_week.strftime("%d/%m/%Y")
      expect(mail.body.encoded).to include("semaine du #{week_starts_on}")
    end

    it "renders the outro" do
      body = mail.body.encoded
      expect(body).to include("Cordialement,")
      expect(body).to include(administrator.organization.service_name)
    end

    context "when the administrator has no activity to report" do
      it "skips delivery" do
        expect(Reports::Weekly.new(administrator).sections).to be_empty
        expect(mail.perform_deliveries).to be(false)
      end
    end

    context "with an offer published last week the authority is actor on" do
      let(:job_offer) do
        create(:published_job_offer, published_at: 1.week.ago.beginning_of_week + 1.day)
      end

      before { create(:job_offer_actor, job_offer:, administrator:, role: :employer) }

      it "lists the offer in the mail body" do
        expect(mail.body.encoded).to include(job_offer.full_title)
      end

      it "delivers the mail" do
        expect(mail.perform_deliveries).to be(true)
      end
    end
  end
end
