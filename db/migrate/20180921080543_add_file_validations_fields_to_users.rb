# frozen_string_literal: true

class AddFileValidationsFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    User::FILES.each do |file|
      add_column :users, "#{file}_is_validated".to_sym, :smallint, default: 0
    end
    JobOffer::FILES.each do |file|
      add_column :job_applications, "#{file}_is_validated".to_sym, :smallint, default: 0
    end
  end
end
