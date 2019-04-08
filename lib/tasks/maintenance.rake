namespace :maintenance do
  namespace :file_management_changes do
    task data_migration: :environment do
      resume = JobApplicationFileType.find_or_create_by! name: "CV", kind: :applicant_provided, from_state: :initial, by_default: true
      cover_letter = JobApplicationFileType.find_or_create_by! name: "Lettre de Motivation", kind: :applicant_provided, from_state: :initial, by_default: true
      diploma = JobApplicationFileType.find_or_create_by! name: "Copie des diplômes",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      proof_of_address = JobApplicationFileType.find_or_create_by! name: "Justificatif de domicile de moins de 6 mois",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      identity = JobApplicationFileType.find_or_create_by! name: "Carte d'identité",
        description: "Carte nationale d’identité recto/verso ou passeport",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      carte_vitale_certificate = JobApplicationFileType.find_or_create_by! name: "Carte Vitale",
        description: "Attestation de carte vitale ou copie de carte vitale (mentionnant le n° INSEE)",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      medical_certificate = JobApplicationFileType.find_or_create_by! name: "Certificat Médical",
        description: "Certificat médical d’aptitude fourni par le médecin de l’établissement ou à défaut par un médecin agréé",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      iban = JobApplicationFileType.find_or_create_by! name: "Relevé d'identité bancaire",
        description: "RIB original au format BIC/IBAN comportant le logo de la banque au nom du signataire du contrat (les RIB sur compte épargne ne sont pas acceptés)",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      transport_ticket = JobApplicationFileType.find_or_create_by! name: "Copie d'un titre de transport (si vous postulez en Île-de-france)",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: true
      JobApplicationFileType.find_or_create_by! name: "Fiche de poste",
        description: "Fiche de poste comportant le code poste ALLIANCE actif et vacant au moment de la date d’effet du recrutement",
        kind: :admin_only,
        from_state: :accepted,
        by_default: true
      JobApplicationFileType.find_or_create_by! name: "FICE transmis à officier sécurité",
        kind: :check_only_admin_only,
        from_state: :accepted,
        by_default: true
      JobApplicationFileType.find_or_create_by! name: "Demande de B2",
        kind: :check_only_admin_only,
        from_state: :accepted,
        by_default: true
      JobApplicationFileType.find_or_create_by! name: "Copie du livret de famille",
        description: "Seulement si marié",
        kind: :applicant_provided,
        from_state: :accepted,
        by_default: false

      JobApplication.include(JobApplicationOldFilesCompat)
      %w(resume cover_letter).each do |file_type_key|
        file_type = eval(file_type_key)
        JobApplication.where("old_#{file_type_key}_file_name IS NOT NULL").all.each do |job_application|
          already_created = job_application.job_application_files.where(job_application_file_type_id: file_type.id).first
          if already_created
            if already_created.content.blank?
              already_created.content = job_application.send(file_type_key)
              already_created.save!
            end
          else
            new_one = job_application.job_application_files.build(job_application_file_type_id: file_type.id)
            new_one.content = job_application.send(file_type_key)
            new_one.save!
          end
        end
      end

      User.include(UserOldFilesCompat)
      %w(diploma proof_of_address identity carte_vitale_certificate medical_certificate iban transport_ticket).each do |file_type_key|
        file_type = eval(file_type_key)
        User.where("old_#{file_type_key}_file_name IS NOT NULL").all.each do |user|
          job_application = user.most_advanced_job_application
          already_created = job_application.job_application_files.where(job_application_file_type_id: file_type.id).first
          if already_created
            if already_created.content.blank?
              already_created.content = user.send(file_type_key)
              already_created.save!
            end
          else
            new_one = job_application.job_application_files.build(job_application_file_type_id: file_type.id)
            new_one.content = user.send(file_type_key)
            new_one.save!
          end
        end
      end


    end
  end
end
