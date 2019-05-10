# frozen_string_literal: true

class RenameOfficialStatusesIntoProfessionalCategories < ActiveRecord::Migration[5.2]
  def change
    rename_table :official_statuses, :professional_categories
    rename_column :job_offers, :official_status_id, :professional_category_id
  end
end
