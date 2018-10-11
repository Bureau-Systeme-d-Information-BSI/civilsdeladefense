# Faker initialization
require 'faker'
I18n.config.available_locales = %w(fr en)
I18n.reload!
Faker::Config.locale = :fr
employer = Employer.create! name: 'DIRISI', code: 'DRI'

bant_admin = Administrator.new email: 'pipo@molo.fr',
  first_name: 'Pipo',
  last_name: 'Molo',
  password: 'pipomolo',
  password_confirmation: 'pipomolo',
  very_first_account: true,
  role: 'bant'
bant_admin.skip_confirmation_notification!
bant_admin.save!
bant_admin.confirm

employer_admin = Administrator.new email: 'employer@molo.fr',
  first_name: 'employer',
  last_name: 'Molo',
  password: 'pipomolo',
  password_confirmation: 'pipomolo',
  very_first_account: true,
  role: 'employer',
  employer: employer
employer_admin.skip_confirmation_notification!
employer_admin.save!
employer_admin.confirm

brh_admin = Administrator.new email: 'brh@molo.fr',
  first_name: 'brh',
  last_name: 'Molo',
  password: 'pipomolo',
  password_confirmation: 'pipomolo',
  very_first_account: true,
  role: 'brh',
  employer: employer
brh_admin.skip_confirmation_notification!
brh_admin.save!
brh_admin.confirm

Category.create! name: 'Administration'
Category.create! name: 'Archives'
Category.create! name: 'Audit'
Category.create! name: 'Communication'
infrastructure = Category.create! name: 'Infrastructure'
sub_infrastructure = Category.create! name: 'Sous-infrastructure', parent: infrastructure
sub_sub_infrastructure = Category.create! name: 'Sous sous-infrastructure', parent: sub_infrastructure
informatique = Category.create! name: 'Informatique'
sub_informatique = Category.create! name: 'Sous-informatique', parent: informatique
sub_sub_informatique = Category.create! name: 'Sous sous-informatique', parent: sub_informatique

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

job_offer = JobOffer.new do |j|
  j.owner = bant_admin
  j.title = 'Ingénieur expert en systemes d’information, réseau et active directory - Chef de section'
  j.category = sub_sub_informatique
  j.professional_category = ProfessionalCategory.first
  j.location = "Rennes, FR"
  j.employer = Employer.last
  j.description = "Placé au sein du commandement des opérations cyber et rattaché à la direction interarmées des réseaux
  d’infrastructure
  et des systèmes d’information (DIRISI), le centre d’analyse en lutte informatique défensive (CALID) est
  le centre
  opérationnel des armées et du ministère de la Défense en charge de la défense des systèmes d’information.
  Au sein de la division investigations numériques, ce personnel a pour mission de créer la section Connaissance des
  Architecture et Remédiation.

  Dans un environnement conditionné par la connaissance des systèmes d’information, l’ingénieur a en charge de définir
  et d’élaborer les bases de connaissances nécessaires à l’analyse contextuelle des attaques informatiques, réaliser les
  analyses contextuelles et anticiper les modalités de confinement, de remédiation et de reconstruction des technologies
  les plus impactantes pour le ministère de la Défense.

  Dans un contexte contraint, la dématérialisation, la capitalisation et la compréhension des données d’architecture sont
  les enjeux du poste. En conséquence, ce poste requiert des connaissances techniques réseaux et en architecture de
  systèmes, des capacités d’analyse et d’innovation."
  j.required_profile = "- Connaissance des architectures réseau et techniques des
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
  j.recruitment_process = "Si votre candidature est pré-selectionnée, vous serez contacté(e) par téléphone pour apprécier vos attentes et motivations.
  Si vous êtes sélectionné(e) après cette première étape, vous serez reçu(e) en entretien par l’employeur et éventuellement le service RH.
  Vous serez à l’issue de cet entretien informé(e) par l’employeur des suites données."
  j.contract_type = ContractType.where(name:"CDD").first
  j.duration_contract = "4 mois"
  j.contract_start_on = Date.new(2019, 1, 1)
  j.is_remote_possible = false
  j.study_level = StudyLevel.last
  j.experience_level = ExperienceLevel.last
  j.sector = Sector.first
  j.is_negotiable = true
  j.estimate_monthly_salary_net = "2500 - 3000€"
  j.estimate_annual_salary_gross = "39000 - 46000€"
  j.option_cover_letter = :mandatory
  j.option_resume = :mandatory
  j.option_photo = :optional
  j.option_website_url = :optional
end
job_offer.save!

job_offer2 = job_offer.dup
job_offer2.title = 'Conducteur d’Opérations (H/F)'
job_offer2.owner = brh_admin
job_offer2.contract_type = ContractType.where(name:"CDI").first
job_offer2.duration_contract = nil
job_offer2.category = sub_sub_infrastructure
job_offer2.identifier = nil
job_offer2.sequential_id = nil
job_offer2.save!

job_offer3 = job_offer.dup
job_offer3.owner = employer_admin
job_offer3.title = 'Responsable Achat d’Infrastructures (H/F)'
job_offer3.category = sub_sub_infrastructure
job_offer3.location = "Brest, FR"
job_offer3.identifier = nil
job_offer3.sequential_id = nil
job_offer3.save!

job_offer.publish!
job_offer2.publish!
job_offer3.publish!

user = User.new email: 'coin@pan.fr',
  first_name: 'Coin',
  last_name: 'Pan',
  password: 'pipomolo',
  password_confirmation: 'pipomolo'
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
  ja.terms_of_service = true
  ja.city = "Paris"
  ja.address_1 = "1 avenue des Champs Elysées"
  ja.country = "FR"
end
file = File.open(Rails.root.join('spec', 'fixtures', 'files', 'document.pdf'))
job_application.cover_letter = file
file = File.open(Rails.root.join('spec', 'fixtures', 'files', 'document.pdf'))
job_application.resume = file
job_application.save!

Audited.audit_class.as_user(bant_admin) do
  Email.create! subject: "subject", body: Faker::Lorem.paragraph(2), job_application: job_application, sender: bant_admin
  Email.create! subject: "subject", body: Faker::Lorem.paragraph(2), job_application: job_application, sender: bant_admin
  Email.create! subject: "subject", body: Faker::Lorem.paragraph(2), job_application: job_application, sender: bant_admin
  Email.create! subject: "subject", body: Faker::Lorem.paragraph(2), job_application: job_application, sender: bant_admin
end

JobOffer.where.not(duration_contract: nil).each do |job_offer|
  30.times do |i|
    user = User.new email: Faker::Internet.email,
      first_name: Faker::Name.first_name ,
      last_name: Faker::Name.last_name ,
      password: 'pipomolo',
      password_confirmation: 'pipomolo'
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
      ja.terms_of_service = true
      ja.city = "Paris"
      ja.address_1 = "1 avenue des Champs Elysées"
      ja.country = "FR"
    end
    file = File.open(Rails.root.join('spec', 'fixtures', 'files', 'document.pdf'))
    job_application.cover_letter = file
    file = File.open(Rails.root.join('spec', 'fixtures', 'files', 'document.pdf'))
    job_application.resume = file
    job_application.job_offer.initial!
    job_application.save!

    3.times do
      Audited.audit_class.as_user(bant_admin) do
        Email.create! subject: "About your application", body: Faker::Lorem.paragraph(2), job_application: job_application, sender: bant_admin
      end
      Audited.audit_class.as_user(user) do
        Email.create! subject: "My application", body: Faker::Lorem.paragraph(2), job_application: job_application, sender: user
      end
    end
  end
end
