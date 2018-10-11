class AddPositionToList < ActiveRecord::Migration[5.2]
  def change
    [ContractType, ExperienceLevel, Sector, StudyLevel].each do |klass|
      add_column klass.to_s.tableize, :position, :integer
      klass.order(:updated_at).each.with_index(1) do |obj, index|
        obj.update_column :position, index
      end
    end
  end
end
