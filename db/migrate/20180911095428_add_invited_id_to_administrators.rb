class AddInvitedIdToAdministrators < ActiveRecord::Migration[5.2]
  def change
    add_reference :administrators, :inviter, type: :uuid, foreign_key: {to_table: :administrators}
  end
end
