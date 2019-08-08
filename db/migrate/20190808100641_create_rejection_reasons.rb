# frozen_string_literal: true

class CreateRejectionReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :rejection_reasons, id: :uuid do |t|
      t.string :name

      t.timestamps
    end

    add_reference :job_applications, :rejection_reason, type: :uuid, foreign_key: true
  end
end
