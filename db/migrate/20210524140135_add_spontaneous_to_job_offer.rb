class AddSpontaneousToJobOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :job_offers, :spontaneous, :boolean, default: false
    add_reference :job_applications, :category, type: :uuid, foreign_key: true
    add_column :job_application_file_types, :spontaneous, :boolean, default: false
  end
end
