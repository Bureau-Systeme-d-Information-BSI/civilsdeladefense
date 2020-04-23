# frozen_string_literal: true

json.array! @job_offers do |job_offer|
  json.cache! job_offer do
    json.code job_offer.identifier
    json.libelle job_offer.title
    json.departement job_offer.county_code
    json.ville job_offer.city
    json.type job_offer.contract_type.name
    json.duree job_offer.duration_contract
    json.niveauEtude job_offer.study_level.official_level
    json.famille job_offer.category.name
    json.lien polymorphic_url(job_offer, routing_type: :url)
    json.source root_url
  end
end
