# frozen_string_literal: true

module Admin::JobOffersHelper
  def charts_per_day_options
    {
      height: '200px',
      library: {
        tooltip: {
          crosshairs: true
        },
        legend: {
          enabled: false
        },
        xAxis: {
          type: 'datetime'
        },
        yAxis: {
          allowDecimals: false
        }
      }
    }
  end
end
