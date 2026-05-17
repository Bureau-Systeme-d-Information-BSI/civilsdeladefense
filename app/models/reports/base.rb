# frozen_string_literal: true

module Reports
  class Base
    include Rails.application.routes.url_helpers

    Section = Struct.new(:key, :human_state, :count, :items, keyword_init: true)
    Item = Struct.new(:title, :link, :applications_count, keyword_init: true)

    def initialize(administrator)
      @administrator = administrator
    end

    def sections
      @sections ||= ([new_offers_section] + states.map { |state| applications_section(state) }).compact
    end

    private

    def states = raise NotImplementedError
  end
end
