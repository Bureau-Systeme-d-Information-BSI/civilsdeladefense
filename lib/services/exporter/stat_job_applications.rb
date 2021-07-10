class Exporter::StatJobApplications < Exporter::Base
  def fill_data
    add_row("Données générales")
    add_row("Nombre de candidatures", stat_data[:job_applications_count])
    add_row(
      "Période choisie",
      "#{I18n.l(stat_data[:date_start].to_date)} à #{I18n.l(stat_data[:date_end].to_date)}"
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
    add_row("", "Expérience")
    experience_levels.each do |model|
      add_row("", "", model.name)
    end
    add_row("", "Niveau d'études")
    study_levels.each do |model|
      add_row("", "", model.name)
    end
  end

  def fill_filling
    add_row("Statistiques des candidatures - pourvoi des postes")
    %w[selected phone_meeting_gt].each do |set_name|
      add_row(
        "",
        I18n.t("#{i18n_key}.title_job_applications_#{set_name}_number_html"),
        stat_data[:per_state].values_at(*JobApplication.send("#{set_name}_states".to_sym)).compact.sum
      )
    end

    add_row(
      "",
      I18n.t("#{i18n_key}.title_job_applications_affected_number_html"),
      stat_data[:per_state].values_at("affected").compact.sum
    )
  end

  def fill_rejection
    add_row("Statistiques des candidats refusés")
    add_row(
      "",
      I18n.t("#{i18n_key}.title_job_applications_all_rejected_number_html"),
      stat_data[:per_state].values_at(*JobApplication.rejected_states).compact.sum
    )
    JobApplication.rejected_states.each do |rejected_state|
      add_row(
        "",
        I18n.t("#{i18n_key}.title_job_applications_#{rejected_state}_number_html"),
        stat_data[:per_state].values_at(rejected_state).compact.sum
      )
    end
    add_row("", "Motif des refus")
    total = stat_data[:per_rejection_reason].values.sum
    stat_data[:per_rejection_reason].each_with_index do |(k, v), index|
      txt = stat_data[:rejection_reasons].detect { |x| x.id == k }&.name || I18n.t("unknown")
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

    total = stat_data[:per_gender].values.sum
    if total > 0
      stat_data[:per_gender].each_with_index do |(k, v), index|
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

    add_row("", "Age moyen")
    total = stat_data[:per_age_range].values.sum
    if total > 0
      stat_data[:per_age_range].each_with_index do |(k, v), index|
        if k.present?
          range = stat_data[:age_ranges].detect { |x| x.id == k }
          col = range.name
        else
          col = I18n.t("unknown")
        end
        percentage = (v * 100.0) / total
        add_row("", "", col, "#{percentage.to_i}%")
      end
    end

    experiences_fit_job_offer_count = stat_data[:per_experiences_fit_job_offer][true] || 0
    if stat_data[:job_applications_count] > 0 && experiences_fit_job_offer_count > 0
      percentage = (experiences_fit_job_offer_count * 100.0) / stat_data[:job_applications_count]
      value = number_to_percentage(percentage, precision: 0)
    else
      value = I18n.t("non_applicable")
    end
    add_row("", "Expérimentés pour l'offre", value)

    has_corporate_experience_count = stat_data[:per_has_corporate_experience][true] || 0
    if stat_data[:job_applications_count] > 0 && has_corporate_experience_count > 0
      percentage = (has_corporate_experience_count * 100.0) / stat_data[:job_applications_count]
      value = number_to_percentage(percentage, precision: 0)
    else
      value = I18n.t("non_applicable")
    end
    add_row("", "Expérimentés dans MinArm", value)

    is_currently_employed_count = stat_data[:per_is_currently_employed][true] || 0
    if stat_data[:job_applications_count] > 0 && is_currently_employed_count > 0
      percentage = (is_currently_employed_count * 100.0) / stat_data[:job_applications_count]
      value = number_to_percentage(percentage, precision: 0)
    else
      value = I18n.t("non_applicable")
    end
    add_row("", "Candidats en poste", value)
  end

  def fill_state_duration
    add_row("Délai moyen par étape de recrutement (en jours)")
    stat_data[:state_duration].each do |from, to, average|
      from_text = JobApplication.human_attribute_name("state/#{from}")
      to_text = JobApplication.human_attribute_name("state/#{to}")
      add_row("", "#{from_text} → #{to_text}", average)
    end
  end

  def employers
    Employer.where(id: stat_data[:q][:employer_id_in])
  end

  def job_offer_categories
    Category.where(id: stat_data[:q][:job_offer_category_id_in])
  end

  def contract_types
    ContractType.where(id: stat_data[:q][:contract_type_id_in])
  end

  def job_offer_bops
    Bop.where(id: stat_data[:q][:job_offer_bop_id_in])
  end

  def experience_levels
    ExperienceLevel.where(id: stat_data[:q][:profile_experience_level_id_in])
  end

  def study_levels
    StudyLevel.where(id: stat_data[:q][:profile_study_level_id_in])
  end

  def i18n_key
    "admin.stats.job_applications.stats_job_applications"
  end

  def stat_data
    data
  end
end
