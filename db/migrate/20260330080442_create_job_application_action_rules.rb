# frozen_string_literal: true

class CreateJobApplicationActionRules < ActiveRecord::Migration[7.1]
  def change
    create_table :job_application_action_rules, id: :uuid do |t|
      t.integer :role, null: false
      t.integer :state, null: false
      t.integer :to_state
      t.boolean :read, null: false, default: false
      t.boolean :manage_user_info, null: false, default: false
      t.boolean :manage_state, null: false, default: false
      t.boolean :manage_file, null: false, default: false
      t.boolean :reject, null: false, default: false
      t.boolean :comment, null: false, default: false
      t.boolean :send_email, null: false, default: false
      t.boolean :validate_dar, null: false, default: false

      t.timestamps
    end

    add_index :job_application_action_rules, %i[role state], unique: true
  end
end
