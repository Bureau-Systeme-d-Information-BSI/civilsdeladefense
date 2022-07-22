class Exporter::StatJobOffers < Exporter::Base
  def fill_data
    add_row("Données générales")
    add_row("Nombre d'offres", data[:job_offers_count])
    add_row(
      "Période choisie",
      "#{I18n.l(data[:date_start].to_date)} à #{I18n.l(data[:date_end].to_date)}"
    )
    fill_filters
    fill_offers
    fill_profiles

    add_row("Délai moyen de recrutement (en jours)", "Date de publication offre → Date d'affectation agent", data[:average_affection])
  end

  def fill_filters
    add_row("Filtres choisis", "Employeur")
    employers.each do |model|
      add_row("", "", model.name)
    end
    add_row("", "Domaine professionnel")
    job_offer_categories.each do |model|
      add_row("", "", model.name)
    end
    add_row("", "Contrat")
    contract_types.each do |model|
      add_row("", "", model.name)
    end
    add_row("", "BOP")
    job_offer_bops.each do |model|
      add_row("", "", model.name)
    end
    add_row("", "Localisation géographique")
    data[:q][:county_in]&.each do |county|
      add_row("", "", county)
    end
  end

  def fill_offers
    add_row("Offres")

    add_row("", "Publiées", data[:job_offer_published])
    add_row("", "À pourvoir", data[:job_offer_unfilled])
    add_row("", "Pourvues", data[:job_offer_filled])
  end

  def fill_profiles
    add_row("Candidatures")
    add_row("", "Total", data[:profiles])
    add_row("", "Candidats disponibles", data[:profile_availables])
  end

  def employers
    Employer.where(id: data[:q][:employer_id_in])
  end

  def job_offer_categories
    Category.where(id: data[:q][:job_offer_category_id_in])
  end

  def contract_types
    ContractType.where(id: data[:q][:contract_type_id_in])
  end

  def job_offer_bops
    Bop.where(id: data[:q][:job_offer_bop_id_in])
  end
end
