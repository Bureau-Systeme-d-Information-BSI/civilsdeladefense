# frozen_string_literal: true

# Faker initialization
I18n.config.available_locales += %w[en]
require "faker"
Faker::Config.locale = :fr

[
  ["01", "Ain", "84", "Auvergne-Rhône-Alpes"],
  ["02", "Aisne", "32", "Hauts-de-France"],
  ["03", "Allier", "84", "Auvergne-Rhône-Alpes"],
  ["04", "Alpes-de-Haute-Provence", "93", "Provence-Alpes-Côte d'Azur"],
  ["05", "Hautes-Alpes", "93", "Provence-Alpes-Côte d'Azur"],
  ["06", "Alpes-Maritimes", "93", "Provence-Alpes-Côte d'Azur"],
  ["07", "Ardèche", "84", "Auvergne-Rhône-Alpes"],
  ["08", "Ardennes", "44", "Grand Est"],
  ["09", "Ariège", "76", "Occitanie"],
  ["10", "Aube", "44", "Grand Est"],
  ["11", "Aude", "76", "Occitanie"],
  ["12", "Aveyron", "76", "Occitanie"],
  ["13", "Bouches-du-Rhône", "93", "Provence-Alpes-Côte d'Azur"],
  ["14", "Calvados", "28", "Normandie"],
  ["15", "Cantal", "84", "Auvergne-Rhône-Alpes"],
  ["16", "Charente", "75", "Nouvelle-Aquitaine"],
  ["17", "Charente-Maritime", "75", "Nouvelle-Aquitaine"],
  ["18", "Cher", "24", "Centre-Val de Loire"],
  ["19", "Corrèze", "75", "Nouvelle-Aquitaine"],
  ["21", "Côte-d'Or", "27", "Bourgogne-Franche-Comté"],
  ["22", "Côtes-d'Armor", "53", "Bretagne"],
  ["23", "Creuse", "75", "Nouvelle-Aquitaine"],
  ["24", "Dordogne", "75", "Nouvelle-Aquitaine"],
  ["25", "Doubs", "27", "Bourgogne-Franche-Comté"],
  ["26", "Drôme", "84", "Auvergne-Rhône-Alpes"],
  ["27", "Eure", "28", "Normandie"],
  ["28", "Eure-et-Loir", "24", "Centre-Val de Loire"],
  ["29", "Finistère", "53", "Bretagne"],
  ["2A", "Corse-du-Sud", "94", "Corse"],
  ["2B", "Haute-Corse", "94", "Corse"],
  ["30", "Gard", "76", "Occitanie"],
  ["31", "Haute-Garonne", "76", "Occitanie"],
  ["32", "Gers", "76", "Occitanie"],
  ["33", "Gironde", "75", "Nouvelle-Aquitaine"],
  ["34", "Hérault", "76", "Occitanie"],
  ["35", "Ille-et-Vilaine", "53", "Bretagne"],
  ["36", "Indre", "24", "Centre-Val de Loire"],
  ["37", "Indre-et-Loire", "24", "Centre-Val de Loire"],
  ["38", "Isère", "84", "Auvergne-Rhône-Alpes"],
  ["39", "Jura", "27", "Bourgogne-Franche-Comté"],
  ["40", "Landes", "75", "Nouvelle-Aquitaine"],
  ["41", "Loir-et-Cher", "24", "Centre-Val de Loire"],
  ["42", "Loire", "84", "Auvergne-Rhône-Alpes"],
  ["43", "Haute-Loire", "84", "Auvergne-Rhône-Alpes"],
  ["44", "Loire-Atlantique", "52", "Pays de la Loire"],
  ["45", "Loiret", "24", "Centre-Val de Loire"],
  ["46", "Lot", "76", "Occitanie"],
  ["47", "Lot-et-Garonne", "75", "Nouvelle-Aquitaine"],
  ["48", "Lozère", "76", "Occitanie"],
  ["49", "Maine-et-Loire", "52", "Pays de la Loire"],
  ["50", "Manche", "28", "Normandie"],
  ["51", "Marne", "44", "Grand Est"],
  ["52", "Haute-Marne", "44", "Grand Est"],
  ["53", "Mayenne", "52", "Pays de la Loire"],
  ["54", "Meurthe-et-Moselle", "44", "Grand Est"],
  ["55", "Meuse", "44", "Grand Est"],
  ["56", "Morbihan", "53", "Bretagne"],
  ["57", "Moselle", "44", "Grand Est"],
  ["58", "Nièvre", "27", "Bourgogne-Franche-Comté"],
  ["59", "Nord", "32", "Hauts-de-France"],
  ["60", "Oise", "32", "Hauts-de-France"],
  ["61", "Orne", "28", "Normandie"],
  ["62", "Pas-de-Calais", "32", "Hauts-de-France"],
  ["63", "Puy-de-Dôme", "84", "Auvergne-Rhône-Alpes"],
  ["64", "Pyrénées-Atlantiques", "75", "Nouvelle-Aquitaine"],
  ["65", "Hautes-Pyrénées", "76", "Occitanie"],
  ["66", "Pyrénées-Orientales", "76", "Occitanie"],
  ["67", "Bas-Rhin", "44", "Grand Est"],
  ["68", "Haut-Rhin", "44", "Grand Est"],
  ["69", "Rhône", "84", "Auvergne-Rhône-Alpes"],
  ["70", "Haute-Saône", "27", "Bourgogne-Franche-Comté"],
  ["71", "Saône-et-Loire", "27", "Bourgogne-Franche-Comté"],
  ["72", "Sarthe", "52", "Pays de la Loire"],
  ["73", "Savoie", "84", "Auvergne-Rhône-Alpes"],
  ["74", "Haute-Savoie", "84", "Auvergne-Rhône-Alpes"],
  ["75", "Paris", "11", "Île-de-France"],
  ["76", "Seine-Maritime", "28", "Normandie"],
  ["77", "Seine-et-Marne", "11", "Île-de-France"],
  ["78", "Yvelines", "11", "Île-de-France"],
  ["79", "Deux-Sèvres", "75", "Nouvelle-Aquitaine"],
  ["80", "Somme", "32", "Hauts-de-France"],
  ["81", "Tarn", "76", "Occitanie"],
  ["82", "Tarn-et-Garonne", "76", "Occitanie"],
  ["83", "Var", "93", "Provence-Alpes-Côte d'Azur"],
  ["84", "Vaucluse", "93", "Provence-Alpes-Côte d'Azur"],
  ["85", "Vendée", "52", "Pays de la Loire"],
  ["86", "Vienne", "75", "Nouvelle-Aquitaine"],
  ["87", "Haute-Vienne", "75", "Nouvelle-Aquitaine"],
  ["88", "Vosges", "44", "Grand Est"],
  ["89", "Yonne", "27", "Bourgogne-Franche-Comté"],
  ["90", "Territoire de Belfort", "27", "Bourgogne-Franche-Comté"],
  ["91", "Essonne", "11", "Île-de-France"],
  ["92", "Hauts-de-Seine", "11", "Île-de-France"],
  ["93", "Seine-Saint-Denis", "11", "Île-de-France"],
  ["94", "Val-de-Marne", "11", "Île-de-France"],
  ["95", "Val-d'Oise", "11", "Île-de-France"],
  ["971", "Guadeloupe", "01", "Guadeloupe"],
  ["972", "Martinique", "02", "Martinique"],
  ["973", "Guyane", "03", "Guyane"],
  ["974", "La Réunion", "04", "La Réunion"],
  ["976", "Mayotte", "06", "Mayotte"],
  ["00", "Aucun", nil, nil],
].each do |data|
  Department.create!(code: data[0], name: data[1], code_region: data[2], name_region: data[3])
end


desc = "Plateforme de recrutement de personnel civils contractuels pour le Ministère des Armées"
desc_short = "Plateforme de recrutement de personnel civils contractuels"
organization = Organization.create!(
  service_name: "Civils de la Défense",
  brand_name: "Ministère\n\ndes Armées",
  prefix_article: "le",
  service_description: desc,
  service_description_short: desc_short,
  job_offer_term_title: "Bienvenue sur l'outil E-recrutement contractuels",
  job_offer_term_subtitle: "Vous souhaitez recourir à un agent contractuel civil car",
  job_offer_term_warning: "C'est impossible"
)
[
  "Le poste fait appel à des compétences techniques spécialisées ou nouvelles (un encart en surbrillance en passant la souris sur la première les compétences sollicitées sont trop récentes ou trop spécialisées pour recourir dans l'immédiat à un fonctionnaire)",
  "Car l'emploi ne requiert pas d'être honoré par un fonctionnaire formé par une école de la fonction publique (poste d'attaché uniquement).",
  "Vous n'avez reçu aucune candidature de fonctionnaire suite à la publication de l'annonce sur CSP et sur MOBILIA."
].each do |str|
  JobOfferTerm.create(name: str)
end

Page.destroy_all
organization ||= Organization.first
root_page = organization.pages.create!(
  title: "Plateforme de recrutement de personnel civils contractuels pour le Ministère des Armées",
  only_link: false
)
organization.pages.create!(
  parent: root_page,
  title: "Déclaration d'accessibilité",
  only_link: false,
  body: "Ici afficher déclaration d'accessibilité"
)
branch_1_page_1 = organization.pages.create!(
  parent: root_page,
  title: "Mentions légales",
  only_link: false,
  body: "Ici afficher mentions légales"
)
branch_1_page_2 = organization.pages.create!(
  parent: branch_1_page_1,
  title: "Conditions générales d’utilisation",
  only_link: false,
  body: "Ici afficher conditions générales d’utilisation"
)
branch_1_page_3 = organization.pages.create!(
  parent: branch_1_page_2,
  title: "Politique de confidentialité",
  only_link: false,
  body: "Ici afficher politique de confidentialité"
)
organization.pages.create!(
  parent: branch_1_page_3,
  title: "Suivi d'audience et vie privée",
  only_link: false,
  body: "Ici afficher suivi d'audience et vie privée"
)

branch_2_page_1 = organization.pages.create!(
  parent: root_page,
  title: "Service-public.fr",
  only_link: true,
  url: "https://www.service-public.fr"
)
branch_2_page_2 = organization.pages.create!(
  parent: branch_2_page_1,
  title: "Legifrance.gouv.fr",
  only_link: true,
  url: "https://www.legifrance.gouv.fr"
)
branch_2_page_3 = organization.pages.create!(
  parent: branch_2_page_2,
  title: "Data.gouv.fr",
  only_link: true,
  url: "https://www.data.gouv.fr"
)
organization.pages.create!(
  parent: branch_2_page_3,
  title: "France.fr",
  only_link: true,
  url: "https://www.france.fr"
)

File.open("spec/fixtures/files/logo_horizontal.svg") do |f|
  organization.logo_horizontal = f
end
File.open("spec/fixtures/files/image_background.jpg") do |f|
  organization.image_background = f
end
organization.save!

employer_parent = Employer.create!(name: "EMA", code: "EMA")
employer = Employer.create!(name: "DIRISI", code: "DRI", parent: employer_parent)

super_admin = Administrator.new(
  email: "admin@example.com",
  first_name: "Admin",
  last_name: "e-recrutement",
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"],
  very_first_account: true,
  role: "admin",
  organization: organization
)
super_admin.skip_confirmation_notification!
super_admin.save!
super_admin.confirm

employer_admin_1 = Administrator.new(
  email: "employeur1@example.com",
  first_name: "Employeur 1",
  last_name: "e-recrutement",
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"],
  very_first_account: true,
  role: "employer",
  employer: employer,
  organization: organization
)
employer_admin_1.skip_confirmation_notification!
employer_admin_1.save!
employer_admin_1.confirm

employer_admin_2 = Administrator.new(
  email: "employeur2@example.com",
  first_name: "Employeur 2",
  last_name: "e-recrutement",
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"],
  very_first_account: true,
  role: "employer",
  employer: employer,
  organization: organization
)
employer_admin_2.skip_confirmation_notification!
employer_admin_2.save!
employer_admin_2.confirm

brh_admin = Administrator.new(
  email: "brh@example.com",
  first_name: "BRH",
  last_name: "e-recrutement",
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"],
  very_first_account: true,
  employer: employer,
  organization: organization
)
brh_admin.skip_confirmation_notification!
brh_admin.save!
brh_admin.confirm

Category.create!(name: "Administration")
Category.create!(name: "Archives")
Category.create!(name: "Audit")
Category.create!(name: "Communication")
infrastructure = Category.create!(name: "Infrastructure")
sub_infrastructure = Category.create!(name: "Opérations", parent: infrastructure)
sub_sub_infrastructure = Category.create!(name: "AWS", parent: sub_infrastructure)
informatique = Category.create!(name: "Informatique")
sub_informatique = Category.create!(name: "Développement", parent: informatique)
sub_sub_informatique = Category.create!(name: "Ruby on Rails", parent: sub_informatique)

ProfessionalCategory.create!(name: "Cadre")
ProfessionalCategory.create!(name: "Non Cadre")

ContractType.create!(name: "CDD", duration: true)
ContractType.create!(name: "CDI")
ContractType.create!(name: "Interim", duration: true)

Sector.create!(name: "Technique")
Sector.create!(name: "Lettre")
Sector.create!(name: "Économie")

StudyLevel.create!(name: "Sans diplôme")
StudyLevel.create!(name: "CAP / BEP")
StudyLevel.create!(name: "BAC")
StudyLevel.create!(name: "BAC+2")
StudyLevel.create!(name: "BAC+5 / Thèse")

ExperienceLevel.create!(name: "Aucune")
ExperienceLevel.create!(name: "1 à 2 ans")
ExperienceLevel.create!(name: "3 à 4 ans")
ExperienceLevel.create!(name: "5 à 6 ans")
ExperienceLevel.create!(name: "> 7 ans")

ContractDuration.create!(name: "6 mois")
ContractDuration.create!(name: "2 ans")
ContractDuration.create!(name: "4 ans")

ForeignLanguage.create!(name: "Anglais")
ForeignLanguage.create!(name: "Allemand")
ForeignLanguage.create!(name: "Russe")
ForeignLanguageLevel.create!(name: "A1")
ForeignLanguageLevel.create!(name: "B2")
ForeignLanguageLevel.create!(name: "C3")

Benefit.create!(name: "Voiture")
Benefit.create!(name: "Crèche")
Benefit.create!(name: "Appartement de fonction")

Level.create!(name: "A")
Level.create!(name: "B")
Level.create!(name: "C")
level_1 = Level.create!(name: "1")
level_2 = Level.create!(name: "2")
Level.create!(name: "3")

Drawback.create!(name: "Astreintes")
Drawback.create!(name: "Travail de nuit")
Drawback.create!(name: "Permis de conduire")

AvailabilityRange.create!(name: "En poste")
AvailabilityRange.create!(name: "Disponible immédiatement")
AvailabilityRange.create!(name: "Disponible sous 1 mois")
AvailabilityRange.create!(name: "Disponible sous 2 mois")
AvailabilityRange.create!(name: "Disponible sous 3 mois ou plus")

resume = JobApplicationFileType.create!(
  name: "CV",
  kind: :applicant_provided,
  from_state: :initial,
  by_default: true
)
cover_letter = JobApplicationFileType.create!(
  name: "Lettre de Motivation",
  kind: :applicant_provided,
  from_state: :initial,
  by_default: true
)
JobApplicationFileType.create!(
  name: "Copie des diplômes",
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
JobApplicationFileType.create!(
  name: "Justificatif de domicile de moins de 6 mois",
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
JobApplicationFileType.create!(
  name: "Carte d'identité",
  description: "Carte nationale d’identité recto/verso ou passeport",
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
description = "Attestation de carte vitale ou copie de carte vitale " \
  "(mentionnant le n° INSEE)"
JobApplicationFileType.create!(
  name: "Carte Vitale",
  description: description,
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
description = "Certificat médical d’aptitude fourni par le médecin de l’établissement" \
  " ou à défaut par un médecin agréé"
JobApplicationFileType.create!(
  name: "Certificat Médical",
  description: description,
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
description = "RIB original au format BIC/IBAN comportant le logo de la banque au nom du " \
  " signataire du contrat (les RIB sur compte épargne ne sont pas acceptés)"
JobApplicationFileType.create!(
  name: "Relevé d'identité bancaire",
  description: description,
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
name = "Copie d'un titre de transport (si vous postulez en Île-de-france)"
JobApplicationFileType.create!(
  name: name,
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: true
)
description = "Fiche de poste comportant le code poste ALLIANCE actif et vacant au moment " \
  "de la date d’effet du recrutement"
JobApplicationFileType.create!(
  name: "Fiche de poste",
  description: description,
  kind: :admin_only,
  from_state: :accepted,
  by_default: true
)
JobApplicationFileType.create!(
  name: "FICE transmis à officier sécurité",
  kind: :check_only_admin_only,
  from_state: :accepted,
  by_default: true
)
JobApplicationFileType.create!(
  name: "Demande de B2",
  kind: :check_only_admin_only,
  from_state: :accepted,
  by_default: true
)
JobApplicationFileType.create!(
  name: "Copie du livret de famille",
  description: "Seulement si marié",
  kind: :applicant_provided,
  from_state: :accepted,
  by_default: false
)

job_offer = JobOffer.new { |j|
  j.organization = organization
  j.owner = super_admin
  j.title = "Ingénieur expert en systemes d’information - Chef de section F/H"
  j.category = sub_sub_informatique
  j.level = level_1
  j.professional_category = ProfessionalCategory.first
  j.location = "Rennes, FR"
  j.employer = Employer.last
  j.mobilia_date = 1.day.ago
  j.mobilia_value = "MOB#{rand(1000..9999)}"
  j.csp_date = 1.day.ago
  j.csp_value = "CSP#{rand(1000..9999)}"
  j.organization_description = "Description de l'organisation"
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
  j.contract_type = ContractType.where(name: "CDD").first
  j.contract_duration = ContractDuration.first
  j.contract_start_on = 1.months.since
  j.is_remote_possible = false
  j.study_level = StudyLevel.last
  j.experience_level = ExperienceLevel.last
  j.sector = Sector.first
  j.estimate_monthly_salary_net = "2500 - 3000€"
  j.estimate_annual_salary_gross = "39000 - 46000€"
  j.job_offer_actors.build(administrator: employer_admin_1, role: :employer)
  j.job_offer_actors.build(administrator: brh_admin, role: :brh)
}
job_offer.save!

job_offer2 = job_offer.dup
job_offer2.title = "Conducteur d’Opérations F/H"
job_offer2.owner = employer_admin_1
job_offer2.contract_type = ContractType.where(name: "CDI").first
job_offer2.contract_duration = nil
job_offer2.contract_start_on = 2.months.since
job_offer2.category = sub_sub_infrastructure
job_offer2.level = level_2
job_offer2.identifier = nil
job_offer2.sequential_id = nil
job_offer2.job_offer_actors.build(administrator: employer_admin_1, role: :employer)
job_offer2.job_offer_actors.build(administrator: brh_admin, role: :brh)
job_offer2.save!

job_offer3 = job_offer.dup
job_offer3.owner = employer_admin_2
job_offer3.contract_start_on = 3.months.since
job_offer3.title = "Responsable Achat d’Infrastructures F/H"
job_offer3.category = sub_sub_infrastructure
job_offer3.level = level_1
job_offer3.location = "Brest, FR"
job_offer3.identifier = nil
job_offer3.sequential_id = nil
job_offer3.job_offer_actors.build(administrator: employer_admin_2, role: :employer)
job_offer3.job_offer_actors.build(administrator: brh_admin, role: :brh)
job_offer3.save!

job_offer4 = job_offer.dup
job_offer4.owner = employer_admin_2
job_offer4.contract_start_on = 4.months.since
job_offer4.title = "Responsable Achat d’Infrastructures F/H"
job_offer4.category = sub_sub_infrastructure
job_offer4.level = level_2
job_offer4.location = "Brest, FR"
job_offer4.identifier = nil
job_offer4.sequential_id = nil
job_offer4.job_offer_actors.build(administrator: employer_admin_2, role: :employer)
job_offer4.job_offer_actors.build(administrator: brh_admin, role: :brh)
job_offer4.save!

job_offer5 = job_offer.dup
job_offer5.owner = employer_admin_2
job_offer5.contract_start_on = 5.months.since
job_offer5.title = "Responsable Achat d’Infrastructures F/H"
job_offer5.category = sub_sub_infrastructure
job_offer5.level = level_1
job_offer5.location = "Brest, FR"
job_offer5.identifier = nil
job_offer5.sequential_id = nil
job_offer5.job_offer_actors.build(administrator: employer_admin_2, role: :employer)
job_offer5.job_offer_actors.build(administrator: brh_admin, role: :brh)
job_offer5.save!

job_offer.publish!
job_offer2.publish!
job_offer3.publish!
job_offer4.publish!
job_offer5.publish!

photo = File.open(Rails.root.join("spec", "fixtures", "files", "avatar.jpg"))
file = File.open(Rails.root.join("spec", "fixtures", "files", "document.pdf"))

user = User.new(
  email: "cvd_coin@example.com",
  first_name: "Coin",
  last_name: "Pan",
  organization: organization,
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"],
  terms_of_service: true,
  certify_majority: true,
  photo: photo,
  current_position: "Développeur",
  phone: "0606060606",
  website_url: "https://www.linkedin.com/in/coin_pan",
  departments: [Department.none],
  receive_job_offer_mails: true
)
user.build_profile(
  gender: "other",
  study_level_id: StudyLevel.all.sample.id,
  profile_foreign_languages_attributes: {
    "0" => { foreign_language_id: ForeignLanguage.first.id, foreign_language_level_id: ForeignLanguageLevel.all.sample.id },
    "1" => { foreign_language_id: ForeignLanguage.last.id, foreign_language_level_id: ForeignLanguageLevel.all.sample.id }
  },
  category_experience_levels_attributes: {
    "0" => { category_id: Category.first.id, experience_level_id: ExperienceLevel.all.sample.id },
    "1" => { category_id: Category.last.id, experience_level_id: ExperienceLevel.all.sample.id }
  }
)
user.skip_confirmation_notification!
user.save!
user.confirm

job_application = JobApplication.new { |ja|
  ja.organization = organization
  ja.job_offer = job_offer
  ja.user = user
}
job_application.job_application_files.build(content: file, job_application_file_type: resume)
job_application.job_application_files.build(content: file, job_application_file_type: cover_letter)
job_application.save!

Audited.audit_class.as_user(super_admin) do
  4.times do
    Email.create!(
      subject: "subject",
      body: Faker::Lorem.paragraph(sentence_count: 2),
      job_application: job_application,
      sender: super_admin
    )
  end
end

job_application2 = JobApplication.new { |ja|
  ja.organization = organization
  ja.job_offer = job_offer2
  ja.user = user
}
job_application2.job_application_files.build(content: file, job_application_file_type: resume)
job_application2.job_application_files.build(content: file, job_application_file_type: cover_letter)
job_application2.save!

user_candidate_of_all = User.new(
  email: "cvd_user@example.com",
  organization: organization,
  first_name: "Nicolas",
  last_name: "Agoini",
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"],
  terms_of_service: true,
  certify_majority: true,
  current_position: "Développeur",
  phone: "0606060606",
  website_url: "https://www.linkedin.com/in/nicolas_agoini",
  departments: Department.all.sample(2)
)
user_candidate_of_all.build_profile(
  gender: "other",
  study_level_id: StudyLevel.all.sample.id,
  profile_foreign_languages_attributes: {
    "0" => { foreign_language_id: ForeignLanguage.first.id, foreign_language_level_id: ForeignLanguageLevel.all.sample.id },
    "1" => { foreign_language_id: ForeignLanguage.last.id, foreign_language_level_id: ForeignLanguageLevel.all.sample.id }
  },
  category_experience_levels_attributes: {
    "0" => { category_id: Category.first.id, experience_level_id: ExperienceLevel.all.sample.id },
    "1" => { category_id: Category.last.id, experience_level_id: ExperienceLevel.all.sample.id }
  }
)
user_candidate_of_all.skip_confirmation_notification!
user_candidate_of_all.save!
user_candidate_of_all.confirm

boolean_choices = [true, false, nil]

JobOffer.where.not(contract_duration_id: nil).where.not(id: [job_offer4.id, job_offer5.id]).each do |job_offer|
  15.times do |_i|
    user = User.new(
      email: Faker::Internet.unique.email,
      organization: organization,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: ENV["SEED_PASSWORD"],
      password_confirmation: ENV["SEED_PASSWORD"],
      terms_of_service: true,
      certify_majority: true,
      current_position: "Développeur",
      phone: "0606060606",
      website_url: "https://www.linkedin.com/in/#{SecureRandom.hex(5)}",
      departments: Department.all.sample(2)
    )
    user.build_profile(
      gender: "other",
      study_level_id: StudyLevel.all.sample.id,
      profile_foreign_languages_attributes: {
        "0" => { foreign_language_id: ForeignLanguage.first.id, foreign_language_level_id: ForeignLanguageLevel.all.sample.id },
        "1" => { foreign_language_id: ForeignLanguage.last.id, foreign_language_level_id: ForeignLanguageLevel.all.sample.id }
        },
      category_experience_levels_attributes: {
        "0" => { category_id: Category.first.id, experience_level_id: ExperienceLevel.all.sample.id },
        "1" => { category_id: Category.last.id, experience_level_id: ExperienceLevel.all.sample.id }
      }
    )
    user.skip_confirmation_notification!
    user.save!
    user.confirm

    job_application = JobApplication.new { |ja|
      ja.organization = organization
      ja.job_offer = job_offer
      ja.user = user
      ja.created_at = 1.upto(6).map { |x| x.days.ago }
      ja.experiences_fit_job_offer = boolean_choices.sample
    }
    job_application.job_application_files.build(content: file, job_application_file_type: resume)
    job_application.job_application_files.build(content: file, job_application_file_type: cover_letter)
    job_application.job_offer.initial!
    job_application.save!

    3.times do
      Audited.audit_class.as_user(super_admin) do
        Email.create!(
          subject: "About your application",
          body: Faker::Lorem.paragraph(sentence_count: 2),
          job_application: job_application,
          sender: super_admin
        )
      end
      Audited.audit_class.as_user(user) do
        Email.create!(
          subject: "My application",
          body: Faker::Lorem.paragraph(sentence_count: 2),
          job_application: job_application,
          sender: user
        )
      end
    end
  end

  job_application = JobApplication.new { |ja|
    ja.organization = organization
    ja.job_offer = job_offer
    ja.user = user_candidate_of_all
  }
  job_application.job_application_files.build(content: file, job_application_file_type: resume)
  job_application.job_application_files.build(content: file, job_application_file_type: cover_letter)
  job_application.job_offer.initial!
  job_application.save!

  3.times do
    Audited.audit_class.as_user(super_admin) do
      Email.create!(
        subject: "About your application",
        body: Faker::Lorem.paragraph(sentence_count: 2),
        job_application: job_application,
        sender: super_admin
      )
    end
    Audited.audit_class.as_user(user_candidate_of_all) do
      Email.create!(
        subject: "My application",
        body: Faker::Lorem.paragraph(sentence_count: 2),
        job_application: job_application,
        sender: user_candidate_of_all
      )
    end
  end
end

EmailTemplate.create!(
  [
    {
      title: "Courriel de proposition de rendez-vous téléphonique",
      subject: "Votre candidature à l'offre XXXX de Civils de la Défense",
      body: "Madame, Monsieur,\r\nJe vous confirme notre rendez-vous...\r\n\r\nSuite à votre candidature pour l'offre N° XXX..."
    },
    {
      title: "Courriel candidature retenue et documents à fournir",
      subject: "Votre candidature à l'offre XXXX de Civils de la Défense – Avis favorable au recrutement",
      body: "Madame, Monsieur,\r\n\r\nJ’ai l’honneur de vous informer que, suite à votre dernier entretien, ..."
    },
    {
      title: "Courriel précisions compétences",
      subject: "Compétences",
      body: "Nous souhaiterions avoir des précisions sur vos compétences."
    },
    {
      title: "Courriel de refus",
      subject: "Votre candidature à l'offre XXX Civils de la Défense ",
      body: "Madame, Monsieur,\r\n\r\nNous avons bien reçu votre candidature et nous vous remercions de l'intérêt que vous ..."
    },
    {
      title: "Courriel entretien tèl.",
      subject: "Disponibilités",
      body: "Pourriez-vous indiquer vos disponibilités ? "
    }
  ]
)

ArchivingReason.create!(
  [
    { name: "Offre suspendue"},
    { name: "Candidat·e trouvé·e"}
  ]
)
