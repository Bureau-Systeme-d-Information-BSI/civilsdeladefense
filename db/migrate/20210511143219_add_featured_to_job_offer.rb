class AddFeaturedToJobOffer < ActiveRecord::Migration[6.1]
  def change
    add_column :job_offers, :featured, :boolean, default: false
  end
end
