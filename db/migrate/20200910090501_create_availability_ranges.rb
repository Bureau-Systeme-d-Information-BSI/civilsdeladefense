# frozen_string_literal: true

class CreateAvailabilityRanges < ActiveRecord::Migration[6.0]
  def change
    create_table :availability_ranges, id: :uuid do |t|
      t.string :name
      t.integer :position

      t.index :name
      t.index :position

      t.timestamps
    end

    add_reference :personal_profiles, :availability_range, type: :uuid, foreign_key: true

    AvailabilityRange.create(name: 'En poste')
    AvailabilityRange.create(name: 'Disponible immédiatement')
    ar3 = AvailabilityRange.create(name: 'Disponible sous 1 mois')
    ar4 = AvailabilityRange.create(name: 'Disponible sous 2 mois')
    ar5 = AvailabilityRange.create(name: 'Disponible sous 3 mois ou plus')

    PersonalProfile.where(availability_date_in_month: 1).update_all(availability_range_id: ar3.id)
    PersonalProfile.where(availability_date_in_month: 2).update_all(availability_range_id: ar4.id)
    PersonalProfile.where('availability_date_in_month >= ?', 3)
                   .update_all(availability_range_id: ar5.id)

    remove_column :personal_profiles, :availability_date_in_month
  end
end
