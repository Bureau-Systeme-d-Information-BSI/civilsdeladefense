# frozen_string_literal: true

# Professional field
class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  acts_as_nested_set counter_cache: :children_count

  has_many :job_offers
  has_many :publicly_visible_job_offers, -> { publicly_visible }, class_name: 'JobOffer'

  def compute_published_job_offers_count!
    if leaf?
      update_column :published_job_offers_count, job_offers.count
    else
      update_column :published_job_offers_count, children.map(&:published_job_offers_count).sum
    end
  end

  def name_with_depth
    "#{'-' * depth} #{name}"
  end
end
