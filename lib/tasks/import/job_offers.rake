namespace :import do
  task job_offers: :environment do
  end

  private

  def archiving_reason_id(archiving_reason_id)
    # Key: id DGA, Value: id CVD
    {
      "4ca13554-9674-4a57-8f07-1b8203efacb1" => "e091c6a6-7039-46b2-a128-ea2df35e949a", # Offre obsolète
      "65661b9b-4fec-49ce-87df-01c0b4172ae3" => "7629b44f-a674-47a0-ac77-ee73d6b38156" # Candidat trouvé
    }.fetch(archiving_reason_id)
  end

  def contract_type_id(contract_type_id)
    # Key: id DGA, Value: id CVD
    {
      "c3ff27eb-6833-4cf2-9dc3-7151201bc68f" => "c42553ee-0b18-4117-b3de-741dca6fd340" # CDI
    }.fetch(contract_type_id)
  end

  def professional_category_id(professional_category_id)
    # Key: id DGA, Value: id CVD
    {
      "1b5a2466-498a-4e13-ac93-0ef43314859a" => "973219d1-c36f-464c-a6a7-acd31a29593f", # Technicien
      "da6827a2-2dfd-4c41-b534-2c37c3d412ce" => "4353f0b7-ca66-4569-8d2f-b0ec6d760d60" # Ingénieur / Cadre
    }.fetch(professional_category_id)
  end
end