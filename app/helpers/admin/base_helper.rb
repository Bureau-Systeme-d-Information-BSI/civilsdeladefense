# frozen_string_literal: true

module Admin::BaseHelper
  def datepicker_display(d)
    d && d.to_date.strftime('%d/%m/%Y')
  end
end
