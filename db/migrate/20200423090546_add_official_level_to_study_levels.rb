# frozen_string_literal: true

class AddOfficialLevelToStudyLevels < ActiveRecord::Migration[6.0]
  def change
    add_column :study_levels, :official_level, :integer
  end
end
