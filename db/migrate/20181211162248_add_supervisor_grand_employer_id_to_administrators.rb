class AddSupervisorGrandEmployerIdToAdministrators < ActiveRecord::Migration[5.2]
  def change
    add_reference(:administrators, :supervisor_administrator, type: :uuid, index: true, foreign_key: {to_table: :administrators})
    add_reference(:administrators, :grand_employer_administrator, type: :uuid, index: true, foreign_key: {to_table: :administrators})
  end
end
