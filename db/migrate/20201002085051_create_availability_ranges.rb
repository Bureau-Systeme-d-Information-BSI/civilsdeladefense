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

    add_reference :profiles, :availability_range, type: :uuid, foreign_key: true

    AvailabilityRange.create(name: 'En poste')
    AvailabilityRange.create(name: 'Disponible immédiatement')
    ar_3 = AvailabilityRange.create(name: 'Disponible sous 1 mois')
    ar_4 = AvailabilityRange.create(name: 'Disponible sous 2 mois')
    ar_5 = AvailabilityRange.create(name: 'Disponible sous 3 mois ou plus')

    Profile.where(availability_date_in_month: 1).update_all(availability_range_id: ar_3.id)
    Profile.where(availability_date_in_month: 2).update_all(availability_range_id: ar_4.id)
    Profile.where('availability_date_in_month >= ?', 3).update_all(availability_range_id: ar_5.id)

    remove_column :profiles, :availability_date_in_month
  end
end
