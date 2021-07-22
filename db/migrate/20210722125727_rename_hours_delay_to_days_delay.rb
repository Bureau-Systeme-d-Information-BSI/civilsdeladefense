class RenameHoursDelayToDaysDelay < ActiveRecord::Migration[6.1]
  def change
    rename_column :organizations, :hours_delay_before_publishing, :days_before_publishing
  end
end
