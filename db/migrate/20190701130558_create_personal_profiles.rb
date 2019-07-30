# frozen_string_literal: true

class CreatePersonalProfiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :gender, :integer, limit: 2
    remove_column :users, :birth_date, :date
    remove_column :users, :nationality, :string, limit: 2
    remove_column :users, :has_residence_permit, :boolean
    remove_column :users, :is_currently_employed, :boolean
    remove_column :users, :availability_date_in_month, :integer
    remove_reference :users, :study_level, type: :uuid, foreign_key: true
    remove_column :users, :study_type, :string
    remove_column :users, :specialization, :string
    remove_reference :users, :experience_level, type: :uuid, foreign_key: true
    remove_column :users, :corporate_experience, :boolean

    create_table :personal_profiles, id: :uuid do |t|
      t.references :personal_profileable, polymorphic: true,
                                          type: :uuid,
                                          index: {
                                            name: 'index_personal_profileable_type_and_id'
                                          }
      t.integer :gender
      t.date :birth_date
      t.string :nationality
      t.string :website_url
      t.string :address_1
      t.string :address_2
      t.string :postcode
      t.string :city
      t.string :country
      t.string :phone
      t.boolean :has_residence_permit
      t.boolean :is_currently_employed
      t.integer :availability_date_in_month
      t.references :study_level, foreign_key: true, type: :uuid
      t.string :study_type
      t.string :specialization
      t.references :experience_level, foreign_key: true, type: :uuid
      t.boolean :has_corporate_experience

      t.timestamps
    end
  end
end
