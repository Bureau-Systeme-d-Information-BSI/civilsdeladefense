# frozen_string_literal: true

module Reports
  # Builds a snapshot of the job offers an administrator is involved in:
  # offers published during the previous calendar week plus open applications
  # grouped by state.
  class Weekly < Base
    private

    STATES = %w[accepted contract_drafting contract_feedback_waiting contract_received affected].freeze

    def new_offers_section
      offers = @administrator.job_offers.last_week
      return nil if offers.empty?

      Section.new(
        key: "new_offers",
        human_state: I18n.t("reports.weekly.sections.new_offers"),
        count: offers.size,
        items: offers.map { |offer| Item.new(title: offer.full_title, link: job_offer_url(offer)) }
      )
    end

    def applications_section(state)
      offers = @administrator.job_offers.with_open_applications_in(state)
      return nil if offers.empty?

      Section.new(
        key: state,
        human_state: I18n.t(
          "reports.sections.application_step",
          state: JobApplication.human_attribute_name("state/#{state}")
        ),
        count: offers.size,
        items: offers.map { |offer| Item.new(title: offer.full_title, link: admin_job_offer_url(offer)) }
      )
    end

    def states = STATES
  end
end
