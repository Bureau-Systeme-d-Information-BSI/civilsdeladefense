# frozen_string_literal: true

# Faker initialization
require 'faker'
I18n.config.available_locales = %w[fr en]
I18n.reload!
Faker::Config.locale = :fr
employer_parent = Employer.create! name: 'EMA',
                                   code: 'EMA'
employer = Employer.create! name: 'DIRISI',
                            code: 'DRI',
                            parent: employer_parent

ENV['SEED_PASSWORD'] ||= '123PIPOmolo*'

bant_admin = Administrator.new email: 'pipo@molo.fr',
                               first_name: 'Pipo',
                               last_name: 'Molo',
                               password: ENV['SEED_PASSWORD'],
                               password_confirmation: ENV['SEED_PASSWORD'],
                               very_first_account: true,
                               role: 'bant'
bant_admin.skip_confirmation_notification!
bant_admin.save!
bant_admin.confirm

employer_admin_1 = Administrator.new email: 'employer1@molo.fr',
                                     first_name: 'employer',
                                     last_name: 'Molo',
                                     password: ENV['SEED_PASSWORD'],
                                     password_confirmation: ENV['SEED_PASSWORD'],
                                     very_first_account: true,
                                     role: 'employer',
                                     employer: employer
employer_admin_1.skip_confirmation_notification!
employer_admin_1.save!
employer_admin_1.confirm

employer_admin_2 = Administrator.new email: 'employer2@molo.fr',
                                     first_name: 'employer',
                                     last_name: 'Molo',
                                     password: ENV['SEED_PASSWORD'],
                                     password_confirmation: ENV['SEED_PASSWORD'],
                                     very_first_account: true,
                                     role: 'employer',
                                     employer: employer
employer_admin_2.skip_confirmation_notification!
employer_admin_2.save!
employer_admin_2.confirm

brh_admin = Administrator.new email: 'brh@molo.fr',
                              first_name: 'brh',
                              last_name: 'Molo',
                              password: ENV['SEED_PASSWORD'],
                              password_confirmation: ENV['SEED_PASSWORD'],
                              very_first_account: true,
                              employer: employer
brh_admin.skip_confirmation_notification!
brh_admin.save!
brh_admin.confirm

Category.create! name: 'Administration'
Category.create! name: 'Archives'
Category.create! name: 'Audit'
Category.create! name: 'Communication'
infrastructure = Category.create! name: 'Infrastructure'
sub_infrastructure = Category.create! name: 'Sous-infrastructure',
                                      parent: infrastructure
sub_sub_infrastructure = Category.create! name: 'Sous sous-infrastructure',
                                          parent: sub_infrastructure
informatique = Category.create! name: 'Informatique'
sub_informatique = Category.create! name: 'Sous-informatique',
                                    parent: informatique
sub_sub_informatique = Category.create! name: 'Sous sous-informatique',
                                        parent: sub_informatique

ProfessionalCategory.create! name: 'Cadre'
ProfessionalCategory.create! name: 'Non Cadre'

ContractType.create! name: 'CDD'
ContractType.create! name: 'CDI'
ContractType.create! name: 'Interim'

Sector.create! name: 'Technique'
Sector.create! name: 'Lettre'
Sector.create! name: 'Économie'

StudyLevel.create! name: 'Sans diplôme'
StudyLevel.create! name: 'CAP / BEP'
StudyLevel.create! name: 'BAC'
StudyLevel.create! name: 'BAC+2'
StudyLevel.create! name: 'BAC+5 / Thèse'

ExperienceLevel.create! name: 'Aucune'
ExperienceLevel.create! name: '1 à 2 ans'
ExperienceLevel.create! name: '3 à 4 ans'
ExperienceLevel.create! name: '5 à 6 ans'
ExperienceLevel.create! name: '> 7 ans'

resume = JobApplicationFileType.create! name: 'CV',
                                        kind: :applicant_provided,
                                        from_state: :initial,
                                        by_default: true
cover_letter = JobApplicationFileType.create! name: 'Lettre de Motivation',
                                              kind: :applicant_provided,
                                              from_state: :initial,
                                              by_default: true
diploma = JobApplicationFileType.create! name: 'Copie des diplômes',
                                         kind: :applicant_provided,
                                         from_state: :accepted,
                                         by_default: true
name = 'Justificatif de domicile de moins de 6 mois'
proof_of_address = JobApplicationFileType.create! name: name,
                                                  kind: :applicant_provided,
                                                  from_state: :accepted,
                                                  by_default: true
description = 'Carte nationale d’identité recto/verso ou passeport'
identity = JobApplicationFileType.create! name: "Carte d'identité",
                                          description: description,
                                          kind: :applicant_provided,
                                          from_state: :accepted,
                                          by_default: true
description = 'Attestation de carte vitale ou copie de carte vitale ' +
              '(mentionnant le n° INSEE)'
carte_vitale_certificate = JobApplicationFileType.create! name: 'Carte Vitale',
                                                          description: description,
                                                          kind: :applicant_provided,
                                                          from_state: :accepted,
                                                          by_default: true
description = 'Certificat médical d’aptitude fourni par le médecin de l’établissement' +
              ' ou à défaut par un médecin agréé'
medical_certificate = JobApplicationFileType.create! name: 'Certificat Médical',
                                                     description: description,
                                                     kind: :applicant_provided,
                                                     from_state: :accepted,
                                                     by_default: true
description = 'RIB original au format BIC/IBAN comportant le logo de la banque au nom du ' +
              ' signataire du contrat (les RIB sur compte épargne ne sont pas acceptés)'
iban = JobApplicationFileType.create! name: "Relevé d'identité bancaire",
                                      description: description,
                                      kind: :applicant_provided,
                                      from_state: :accepted,
                                      by_default: true
name = 'Copie d\'un titre de transport (si vous postulez en Île-de-france)'
transport_ticket = JobApplicationFileType.create! name: name,
                                                  kind: :applicant_provided,
                                                  from_state: :accepted,
                                                  by_default: true
description = 'Fiche de poste comportant le code poste ALLIANCE actif et vacant au moment ' +
              'de la date d’effet du recrutement'
JobApplicationFileType.create! name: 'Fiche de poste',
                               description: description,
                               kind: :admin_only,
                               from_state: :accepted,
                               by_default: true
JobApplicationFileType.create! name: 'FICE transmis à officier sécurité',
                               kind: :check_only_admin_only,
                               from_state: :accepted,
                               by_default: true
JobApplicationFileType.create! name: 'Demande de B2',
                               kind: :check_only_admin_only,
                               from_state: :accepted,
                               by_default: true
JobApplicationFileType.create! name: 'Copie du livret de famille',
                               description: 'Seulement si marié',
                               kind: :applicant_provided,
                               from_state: :accepted,
                               by_default: false

job_offer = JobOffer.new do |j|
  j.owner = bant_admin
  j.title = 'Ingénieur expert en systemes d’information, réseau et active directory - ' +
            'Chef de section'
  j.category = sub_sub_informatique
  j.professional_category = ProfessionalCategory.first
  j.location = 'Rennes, FR'
  j.employer = Employer.last
  j.description = <<~HEREDOC
  Placé au sein du commandement des opérations cyber et rattaché à la direction interarmées
  des réseaux d’infrastructure
  et des systèmes d’information (DIRISI), le centre d’analyse en lutte informatique défensive
  (CALID) est le centre
  opérationnel des armées et du ministère de la Défense en charge de la défense
  des systèmes d’information.
  Au sein de la division investigations numériques, ce personnel a pour mission de
  créer la section Connaissance des Architecture et Remédiation.

  Dans un environnement conditionné par la connaissance des systèmes d’information,
  l’ingénieur a en charge de définir
  et d’élaborer les bases de connaissances nécessaires à l’analyse contextuelle des attaques
  informatiques, réaliser les
  analyses contextuelles et anticiper les modalités de confinement, de remédiation et de
  reconstruction des technologies
  les plus impactantes pour le ministère de la Défense.

  Dans un contexte contraint, la dématérialisation, la capitalisation et la compréhension
  des données d’architecture sont
  les enjeux du poste. En conséquence, ce poste requiert des connaissances techniques
  réseaux et en architecture de
  systèmes, des capacités d’analyse et d’innovation.
  HEREDOC
  j.required_profile = <<~HEREDOC
  - Connaissance des architectures réseau et techniques des
  systèmes d’informations
  - Méthodes d’évaluation et de maîtrise des risques
  - Reconstruction d’Active Directory
  - Gestion de crise et planification opérationnelle
  - Outils de modélisation
  - Sécurité des systèmes d’information et de communication
  - Ouverture d’esprit et capacité d’innovation
  - Relationnel
  - Etre capable de diriger une équipe technique
  - Connaissance de l’anglais technique"
  HEREDOC
  j.recruitment_process = <<~HEREDOC
  Si votre candidature est pré-selectionnée,
  vous serez contacté(e) par téléphone pour apprécier vos attentes et motivations.
  Si vous êtes sélectionné(e) après cette première étape, vous serez reçu(e) en
  entretien par l’employeur et éventuellement le service RH.
  Vous serez à l’issue de cet entretien informé(e) par l’employeur des suites données.
  HEREDOC
  j.contract_type = ContractType.where(name: 'CDD').first
  j.duration_contract = '4 mois'
  j.contract_start_on = Date.new(2019, 1, 1)
  j.is_remote_possible = false
  j.study_level = StudyLevel.last
  j.experience_level = ExperienceLevel.last
  j.sector = Sector.first
  j.estimate_monthly_salary_net = '2500 - 3000€'
  j.estimate_annual_salary_gross = '39000 - 46000€'
  j.job_offer_actors.build(administrator: employer_admin_1, role: :employer)
  j.job_offer_actors.build(administrator: brh_admin, role: :brh)
end
job_offer.save!

job_offer2 = job_offer.dup
job_offer2.title = 'Conducteur d’Opérations (H/F)'
job_offer2.owner = employer_admin_1
job_offer2.contract_type = ContractType.where(name: 'CDI').first
job_offer2.duration_contract = nil
job_offer2.category = sub_sub_infrastructure
job_offer2.identifier = nil
job_offer2.sequential_id = nil
job_offer2.job_offer_actors.build(administrator: employer_admin_1, role: :employer)
job_offer2.job_offer_actors.build(administrator: brh_admin, role: :brh)
job_offer2.save!

job_offer3 = job_offer.dup
job_offer3.owner = employer_admin_2
job_offer3.title = 'Responsable Achat d’Infrastructures (H/F)'
job_offer3.category = sub_sub_infrastructure
job_offer3.location = 'Brest, FR'
job_offer3.identifier = nil
job_offer3.sequential_id = nil
job_offer3.job_offer_actors.build(administrator: employer_admin_2, role: :employer)
job_offer3.job_offer_actors.build(administrator: brh_admin, role: :brh)
job_offer3.save!

job_offer.publish!
job_offer2.publish!
job_offer3.publish!

photo = File.open(Rails.root.join('spec', 'fixtures', 'files', 'avatar.jpg'))
file = File.open(Rails.root.join('spec', 'fixtures', 'files', 'document.pdf'))

user = User.new email: 'coin@pan.fr',
                first_name: 'Coin',
                last_name: 'Pan',
                password: ENV['SEED_PASSWORD'],
                password_confirmation: ENV['SEED_PASSWORD'],
                photo: photo
user.skip_confirmation_notification!
user.save!
user.confirm

job_application = JobApplication.new do |ja|
  ja.job_offer = job_offer
  ja.user = user
  ja.first_name = user.first_name
  ja.last_name = user.last_name
  ja.current_position = 'Dev'
  ja.phone = '0606060606'
  ja.terms_of_service = ja.certify_majority = true
  ja.city = 'Paris'
  ja.address_1 = '1 avenue des Champs Elysées'
  ja.country = 'FR'
end
job_application.job_application_files.build content: file,
                                            job_application_file_type: resume
job_application.job_application_files.build content: file,
                                            job_application_file_type: cover_letter
job_application.save!

Audited.audit_class.as_user(bant_admin) do
  4.times do
    Email.create! subject: 'subject',
                  body: Faker::Lorem.paragraph(2),
                  job_application: job_application,
                  sender: bant_admin
  end
end

user_candidate_of_all = User.new email: Faker::Internet.email,
                                 first_name: 'Nicolas',
                                 last_name: 'Agoini',
                                 password: ENV['SEED_PASSWORD'],
                                 password_confirmation: ENV['SEED_PASSWORD']
user_candidate_of_all.skip_confirmation_notification!
user_candidate_of_all.save!
user_candidate_of_all.confirm

JobOffer.where.not(duration_contract: nil).each do |job_offer|
  5.times do |_i|
    user = User.new email: Faker::Internet.email,
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    password: ENV['SEED_PASSWORD'],
                    password_confirmation: ENV['SEED_PASSWORD']
    user.skip_confirmation_notification!
    user.save!
    user.confirm

    job_application = JobApplication.new do |ja|
      ja.job_offer = job_offer
      ja.user = user
      ja.first_name = user.first_name
      ja.last_name = user.last_name
      ja.current_position = 'Dev'
      ja.phone = '0606060606'
      ja.terms_of_service = ja.certify_majority = true
      ja.city = 'Paris'
      ja.address_1 = '1 avenue des Champs Elysées'
      ja.country = 'FR'
    end
    job_application.job_application_files.build content: file,
                                                job_application_file_type: resume
    job_application.job_application_files.build content: file,
                                                job_application_file_type: cover_letter
    job_application.job_offer.initial!
    job_application.save!

    3.times do
      Audited.audit_class.as_user(bant_admin) do
        Email.create! subject: 'About your application',
                      body: Faker::Lorem.paragraph(2),
                      job_application: job_application,
                      sender: bant_admin
      end
      Audited.audit_class.as_user(user) do
        Email.create! subject: 'My application',
                      body: Faker::Lorem.paragraph(2),
                      job_application: job_application,
                      sender: user
      end
    end
  end

  job_application = JobApplication.new do |ja|
    ja.job_offer = job_offer
    ja.user = user_candidate_of_all
    ja.first_name = user_candidate_of_all.first_name
    ja.last_name = user_candidate_of_all.last_name
    ja.current_position = 'Dev'
    ja.phone = '0606060606'
    ja.terms_of_service = ja.certify_majority = true
    ja.city = 'Paris'
    ja.address_1 = '1 avenue des Champs Elysées'
    ja.country = 'FR'
  end
  job_application.job_application_files.build content: file,
                                              job_application_file_type: resume
  job_application.job_application_files.build content: file,
                                              job_application_file_type: cover_letter
  job_application.job_offer.initial!
  job_application.save!

  3.times do
    Audited.audit_class.as_user(bant_admin) do
      Email.create! subject: 'About your application',
                    body: Faker::Lorem.paragraph(2),
                    job_application: job_application,
                    sender: bant_admin
    end
    Audited.audit_class.as_user(user_candidate_of_all) do
      Email.create! subject: 'My application',
                    body: Faker::Lorem.paragraph(2),
                    job_application: job_application,
                    sender: user_candidate_of_all
    end
  end
end
