# frozen_string_literal: true

class RemoveOldFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :job_application_file_types, :old_from_state

    cols = %i[old_cover_letter_is_validated old_resume_is_validated old_photo_is_validated
              old_cover_letter_file_name old_cover_letter_content_type
              old_cover_letter_file_size old_cover_letter_updated_at old_resume_file_name
              old_resume_content_type old_resume_file_size old_resume_updated_at
              old_photo_file_name old_photo_content_type old_photo_file_size old_photo_updated_at]

    cols.each do |col|
      remove_column :job_applications, col
    end

    cols = %i[old_resume_file_name old_resume_content_type old_resume_file_size
              old_resume_updated_at old_cover_letter_file_name old_cover_letter_content_type
              old_cover_letter_file_size old_cover_letter_updated_at old_diploma_file_name
              old_diploma_content_type old_diploma_file_size old_diploma_updated_at
              old_identity_file_name old_identity_content_type old_identity_file_size
              old_identity_updated_at old_carte_vitale_certificate_file_name
              old_carte_vitale_certificate_content_type old_carte_vitale_certificate_file_size
              old_carte_vitale_certificate_updated_at old_proof_of_address_file_name
              old_proof_of_address_content_type old_proof_of_address_file_size
              old_proof_of_address_updated_at old_medical_certificate_file_name
              old_medical_certificate_content_type old_medical_certificate_file_size
              old_medical_certificate_updated_at old_contract_file_name
              old_contract_content_type old_contract_file_size old_contract_updated_at
              old_iban_file_name old_iban_content_type old_iban_file_size old_iban_updated_at
              old_agent_statement_file_name old_agent_statement_content_type
              old_agent_statement_file_size old_agent_statement_updated_at
              old_request_transport_costs_file_name old_request_transport_costs_content_type
              old_request_transport_costs_file_size old_request_transport_costs_updated_at
              old_request_family_supplement_file_name old_request_family_supplement_content_type
              old_request_family_supplement_file_size old_request_family_supplement_updated_at
              old_statement_sft_file_name old_statement_sft_content_type
              old_statement_sft_file_size old_statement_sft_updated_at
              old_transport_ticket_file_name old_transport_ticket_content_type
              old_transport_ticket_file_size old_transport_ticket_updated_at]

    cols.each do |col|
      remove_column :users, col
    end
  end
end
