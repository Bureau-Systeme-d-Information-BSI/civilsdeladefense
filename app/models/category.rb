# frozen_string_literal: true

# Professional field
class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  acts_as_nested_set counter_cache: :children_count

  has_many :job_offers, dependent: :nullify
  has_many :publicly_visible_job_offers, -> { publicly_visible }, class_name: "JobOffer", inverse_of: :category, dependent: :nullify
  has_many :job_applications, dependent: :nullify

  def compute_published_job_offers_count!
    if leaf?
      update_column :published_job_offers_count, publicly_visible_job_offers.count # rubocop:disable Rails/SkipsModelValidations
    else
      update_column :published_job_offers_count, children.map(&:published_job_offers_count).sum # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def name_with_depth
    "#{"-" * depth} #{name}"
  end
end

# == Schema Information
#
# Table name: categories
#
#  id                         :uuid             not null, primary key
#  children_count             :integer          default(0), not null
#  depth                      :integer          default(0)
#  lft                        :integer
#  name                       :string
#  published_job_offers_count :integer          default(0), not null
#  rgt                        :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  parent_id                  :uuid
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
