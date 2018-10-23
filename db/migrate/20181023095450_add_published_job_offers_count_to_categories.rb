class AddPublishedJobOffersCountToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :published_job_offers_count, :integer, null: false, default: 0

    Category.roots.each do |root|
      root.leaves.each do |category|
        category.self_and_ancestors.reverse.each do |cat|
          cat.compute_published_job_offers_count!
        end
      end
    end
  end
end
