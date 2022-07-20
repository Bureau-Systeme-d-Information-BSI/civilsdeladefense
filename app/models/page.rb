# frozen_string_literal: true

# CMS Page for front-end display
class Page < ApplicationRecord
  acts_as_nested_set scope: :organization,
    counter_cache: :children_count,
    dependent: :restrict_with_exception
  after_save :reinsert_previous_child

  extend FriendlyId
  friendly_id :title, use: %i[slugged history finders]

  validates :title, presence: true

  belongs_to :organization, touch: true

  def self.contact
    where("title ILIKE '%contact%'").first
  end

  def reinsert_children_branch
    return unless children_count.positive?

    children.first.move_to_child_of(parent)
  end

  def move_higher
    if depth == 1
      move_left
    else
      current_parent = parent
      current_grand_parent = parent.parent
      current_child = children.first
      if current_parent && current_grand_parent
        ActiveRecord::Base.transaction do
          move_to_child_of(current_grand_parent)
          current_child&.move_to_child_of(parent)
          current_parent.move_to_child_of(self)
        end
      end
    end
  end

  def move_lower
    if depth == 1
      move_right
    else
      current_parent = parent
      current_child = children.first
      if current_child
        current_grand_child = current_child.children.first
        current_child.move_to_child_of(current_parent)
        current_grand_child&.move_to_child_of(self)
        move_to_child_of(current_child)
      end
    end
  end

  private

  def reinsert_previous_child
    previous_child = Page.where(parent_id: parent_id)
      .where("depth >= ?", 2)
      .where.not(id: id).first
    previous_child&.move_to_child_of(self)
  end
end

# == Schema Information
#
# Table name: pages
#
#  id              :uuid             not null, primary key
#  body            :text
#  children_count  :integer          default(0), not null
#  depth           :integer
#  lft             :integer          not null
#  og_description  :string
#  og_title        :string
#  only_link       :boolean          default(FALSE), not null
#  rgt             :integer          not null
#  slug            :string
#  title           :string
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  parent_id       :uuid
#
# Indexes
#
#  index_pages_on_lft              (lft)
#  index_pages_on_organization_id  (organization_id)
#  index_pages_on_parent_id        (parent_id)
#  index_pages_on_rgt              (rgt)
#
# Foreign Keys
#
#  fk_rails_8ecbce3eb4  (organization_id => organizations.id)
#
