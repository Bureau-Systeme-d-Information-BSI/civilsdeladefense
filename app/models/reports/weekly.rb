# frozen_string_literal: true

module Reports
  # Builds a snapshot of the job offers an administrator is involved in:
  # offers published during the previous calendar week plus open applications
  # grouped by state.
  class Weekly
    include Rails.application.routes.url_helpers

    Section = Struct.new(:key, :human_state, :count, :items, keyword_init: true)
    Item = Struct.new(:title, :link, keyword_init: true)

    def initialize(administrator)
      @administrator = administrator
    end

    def sections
      @sections ||= [new_offers_section] + JobApplication::ORDERED_STATES.map { |state| applications_section(state) }
    end

    private

    def new_offers_section
      offers = @administrator.job_offers.last_week
      Section.new(
        key: "new_offers",
        human_state: I18n.t("reports.weekly.sections.new_offers"),
        count: offers.size,
        items: offers.map { |offer| Item.new(title: offer.full_title, link: job_offer_url(offer)) }
      )
    end

    def applications_section(state)
      offers = @administrator.job_offers.with_open_applications_in(state)
      Section.new(
        key: state,
        human_state: JobApplication.human_attribute_name("state/#{state}"),
        count: offers.size,
        items: offers.map { |offer| Item.new(title: offer.full_title, link: admin_job_offer_url(offer)) }
      )
    end
  end
end
