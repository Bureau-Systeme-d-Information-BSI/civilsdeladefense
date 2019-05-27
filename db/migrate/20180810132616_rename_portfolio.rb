# frozen_string_literal: true

class RenamePortfolio < ActiveRecord::Migration[5.2]
  def change
    rename_column(:job_offers, :option_portfolio, :option_portfolio_url)
  end
end
