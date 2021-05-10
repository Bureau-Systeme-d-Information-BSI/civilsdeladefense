class Exporter::Users < Exporter::Base
  def fill_data
    data.each_with_index do |line, index|
      format_user(line, index)
    end
  end

  def format_user(user, index)
    last_job_application = user.last_job_application
    sheet.add_row(["Carte candidat N°#{index}"])
    sheet.add_row([user.first_name])
    sheet.add_row([user.last_name])
    sheet.add_row([user.current_position])
    sheet.add_row([user.job_applications_count])
    sheet.add_row([last_job_application.aasm.human_state]) if last_job_application
    sheet.add_row([I18n.l(last_job_application.created_at.to_date)]) if last_job_application
    sheet.add_row([user.email])
    sheet.add_row([user.phone])
    sheet.add_row(["Candidatures"])
    user.job_applications.each do |job_application|
      sheet.add_row(format_job_application(job_application))
    end
    sheet.add_row([])
  end

  def format_job_application(job_application)
    profile = job_application.profile
    [
      nil,
      job_application.job_offer.employer.name,
      job_application.created_at,
      JobApplication.human_attribute_name("state/#{job_application.state}"),
      profile.gender ? Profile.human_attribute_name("gender/#{profile.gender}") : "",
      profile.has_corporate_experience ? "Expérience dans l'entreprise" : "",
      profile.is_currently_employed ? "Actuellement employé" : "",
      profile.availability_range&.name,
      profile.experience_level&.name,
      profile.study_level&.name,
      profile.profile_foreign_languages.map { |fl| "#{fl.foreign_language.name} #{fl.foreign_language_level.name}" }.join("; ")
    ]
  end
end
