# frozen_string_literal: true

module JobApplication::Preselectable
  extend ActiveSupport::Concern

  included do
    enum preselection: {
      pending: 0,
      favorite: 1,
      unfavorite: -1
    }
  end

  def preselect_as_favorite! = update!(preselection: :favorite)

  def unpreselect_as_favorite! = update!(preselection: :pending)

  def preselect_as_unfavorite! = update!(preselection: :unfavorite)

  def unpreselect_as_unfavorite! = update!(preselection: :pending)
end
