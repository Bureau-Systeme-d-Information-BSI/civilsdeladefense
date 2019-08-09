# frozen_string_literal: true

module Admin::JobOffersHelper
  def charts_per_day_options
    {
      height: '200px',
      library: {
        elements: {
          line: {
            tension: 0
          }
        }
      }
    }
  end
end
