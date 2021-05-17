class Exporter::Users < Exporter::Base
  def fill_data
    data.each_with_index do |line, index|
      format_user(line, index)
    end
  end

  def format_user(user, index)
    last_job_application = user.last_job_application
    sheet.add_row(["Carte candidat N°#{index + 1}"])
    sheet.add_row(["Prénom", user.first_name])
    sheet.add_row(["Nom", user.last_name])
    sheet.add_row(["Poste actuel", user.current_position])
    sheet.add_row(["Nombre de candidatures", user.job_applications_count])
    sheet.add_row(["Status", last_job_application.aasm.human_state]) if last_job_application
    sheet.add_row(["Date de candidature", I18n.l(last_job_application.created_at.to_date)]) if last_job_application
    sheet.add_row(["Courriel", user.email])
    sheet.add_row(["Numéro de téléphone", user.phone])
    sheet.add_row(["Candidatures"])
    sheet.add_row([
      "CANDIDATURES CANDIDAT N°#{index + 1}", "Employeur", "Date de la candidature",
      "Status", "Genre", "Expérience dans l'entreprise", "Actuellement employé",
      "Disponibilité", "Expérience professionnel", "Niveau d'études", "Langues étrangères"
    ])
    user.job_applications.each_with_index do |job_application, index|
      sheet.add_row(format_job_application(job_application, index))
    end
    sheet.add_row([])
  end

  def format_job_application(job_application, index)
    profile = job_application.profile
    [
      nil,
      job_application.job_offer.employer.name,
      job_application.created_at,
      JobApplication.human_attribute_name("state/#{job_application.state}"),
      profile.gender ? Profile.human_attribute_name("gender/#{profile.gender}") : "",
      profile.has_corporate_experience ? "Oui" : "Non",
      profile.is_currently_employed ? "Oui" : "Non",
      profile.availability_range&.name,
      profile.experience_level&.name,
      profile.study_level&.name,
      profile.profile_foreign_languages.map { |fl| "#{fl.foreign_language.name} #{fl.foreign_language_level.name}" }.join("; ")
    ]
  end
end
