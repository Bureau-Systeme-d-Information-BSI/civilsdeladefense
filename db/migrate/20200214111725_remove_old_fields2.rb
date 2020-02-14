# frozen_string_literal: true

class RemoveOldFields2 < ActiveRecord::Migration[6.0]
  def change
    cols = %i[resume_is_validated cover_letter_is_validated diploma_is_validated
              identity_is_validated carte_vitale_certificate_is_validated
              proof_of_address_is_validated medical_certificate_is_validated contract_is_validated
              iban_is_validated agent_statement_is_validated request_transport_costs_is_validated
              request_family_supplement_is_validated statement_sft_is_validated
              transport_ticket_is_validated]

    cols.each do |col|
      remove_column :users, col
    end
  end
end
