# frozen_string_literal: true

module Admin::JobOffersHelper
  def archived_listing? = controller.is_a?(Admin::JobOffers::ArchivedController)

  def featured_listing? = controller.is_a?(Admin::JobOffers::FeaturedController)

  def charts_per_day_options
    {
      height: "200px",
      library: {
        tooltip: {
          crosshairs: true
        },
        legend: {
          enabled: false
        },
        xAxis: {
          type: "datetime"
        },
        yAxis: {
          allowDecimals: false
        }
      }
    }
  end
end
