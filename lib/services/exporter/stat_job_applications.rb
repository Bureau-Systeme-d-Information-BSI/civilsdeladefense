class Exporter::StatJobApplications < Exporter::Base
  def fill_data
    add_row("Données générales")
    add_row("Nombre de candidatures", data[:job_applications_count])
    add_row(
      "Période choisie",
      "#{I18n.l(data[:date_start].to_date)} à #{I18n.l(data[:date_end].to_date)}"
    )
    fill_filters
    fill_filling
    fill_rejection
    fill_application
    fill_state_duration
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
  end

  def fill_filling
    add_row("Statistiques des candidatures - pourvoi des postes")
    %w[selected phone_meeting_gt].each do |set_name|
      add_row(
        "",
        I18n.t("#{i18n_key}.title_job_applications_#{set_name}_number_html"),
        data[:per_state].values_at(*JobApplication.send("#{set_name}_states".to_sym)).compact.sum
      )
    end

    add_row(
      "",
      I18n.t("#{i18n_key}.title_job_applications_affected_number_html"),
      data[:per_state].values_at("affected").compact.sum
    )
  end

  def fill_rejection
    add_row("Statistiques des candidats refusés")
    add_row(
      "",
      I18n.t("#{i18n_key}.title_job_applications_all_rejected_number_html"),
      data[:per_state].values_at(*JobApplication.rejected_states).compact.sum
    )
    JobApplication.rejected_states.each do |rejected_state|
      add_row(
        "",
        I18n.t("#{i18n_key}.title_job_applications_#{rejected_state}_number_html"),
        data[:per_state].values_at(rejected_state).compact.sum
      )
    end
    add_row("", "Motif des refus")
    total = data[:per_rejection_reason].values.sum
    data[:per_rejection_reason].each_with_index do |(k, v), index|
      txt = data[:rejection_reasons].detect { |x| x.id == k }&.name || I18n.t("unknown")
      percentage = (v * 100.0) / total
      add_row(
        "",
        "",
        txt,
        number_to_percentage(percentage, precision: 2)
      )
    end
  end

  def fill_application
    add_row("Statistiques des candidats", "Genre")

    total = data[:per_gender].values.sum
    if total > 0
      data[:per_gender].each_with_index do |(k, v), index|
        if k.present?
          val = Profile.genders.key(k)
          col = Profile.human_attribute_name("gender/#{val}")
        else
          col = I18n.t("unknown")
        end
        percentage = (v * 100.0) / total
        add_row("", "", col, "#{percentage.to_i}%")
      end
    end

    total = data[:per_age_range].values.sum
    if total > 0
      data[:per_age_range].each_with_index do |(k, v), index|
        if k.present?
          range = data[:age_ranges].detect { |x| x.id == k }
          col = range.name
        else
          col = I18n.t("unknown")
        end
        percentage = (v * 100.0) / total
        add_row("", "", col, "#{percentage.to_i}%")
      end
    end

    experiences_fit_job_offer_count = data[:per_experiences_fit_job_offer][true] || 0
    if data[:job_applications_count] > 0 && experiences_fit_job_offer_count > 0
      percentage = (experiences_fit_job_offer_count * 100.0) / data[:job_applications_count]
      value = number_to_percentage(percentage, precision: 0)
    else
      value = I18n.t("non_applicable")
    end
    add_row("", "Expérimentés pour l'offre", value)

    has_corporate_experience_count = data[:per_has_corporate_experience][true] || 0
    if data[:job_applications_count] > 0 && has_corporate_experience_count > 0
      percentage = (has_corporate_experience_count * 100.0) / data[:job_applications_count]
      value = number_to_percentage(percentage, precision: 0)
    else
      value = I18n.t("non_applicable")
    end
    add_row("", "Expérimentés dans MinArm", value)

    is_currently_employed_count = data[:per_is_currently_employed][true] || 0
    if data[:job_applications_count] > 0 && is_currently_employed_count > 0
      percentage = (is_currently_employed_count * 100.0) / data[:job_applications_count]
      value = number_to_percentage(percentage, precision: 0)
    else
      value = I18n.t("non_applicable")
    end
    add_row("", "Candidats en poste", value)
  end

  def fill_state_duration
    add_row("Délai moyen par étape de recrutement (en jours)")
    data[:state_duration].each do |from, to, average|
      from_text = JobApplication.human_attribute_name("state/#{from}")
      to_text = JobApplication.human_attribute_name("state/#{to}")
      add_row("", "#{from_text} → #{to_text}", average)
    end
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

  def i18n_key
    "admin.stats.job_applications.stats_job_applications"
  end
end
