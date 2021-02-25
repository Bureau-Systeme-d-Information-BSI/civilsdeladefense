# frozen_string_literal: true

class DepreciateFileFields < ActiveRecord::Migration[5.2]
  def change
    %i[resume cover_letter diploma identity carte_vitale_certificate proof_of_address
      medical_certificate iban transport_ticket contract agent_statement
      request_transport_costs request_family_supplement statement_sft].each do |field|
      %i[file_name content_type file_size updated_at].each do |field_2|
        rename_column :users, "#{field}_#{field_2}", "old_#{field}_#{field_2}"
      end
    end

    %i[resume cover_letter photo].each do |field|
      %i[file_name content_type file_size updated_at is_validated].each do |field_2|
        rename_column :job_applications, "#{field}_#{field_2}", "old_#{field}_#{field_2}"
      end
    end
  end
end
