administrator = Administrator.new email: 'pipo@molo.fr',
  first_name: 'Pipo',
  last_name: 'Molo',
  password: 'pipomolo',
  password_confirmation: 'pipomolo',
  role: 'bant'
administrator.skip_confirmation_notification!
administrator.save!
administrator.confirm

Category.create! name: 'Administration'
Category.create! name: 'Archives'
Category.create! name: 'Audit'
Category.create! name: 'Communication'
infrastructure = Category.create! name: 'Infrastructure'
informatique = Category.create! name: 'Informatique'

OfficialStatus.create! name: 'Cadre'
OfficialStatus.create! name: 'Non Cadre'

Employer.create! name: 'DIRISI', code: 'DRI'

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
  j.owner = administrator
  j.title = 'Ingénieur expert en systemes d’information, réseau et active directory - Chef de section'
  j.category = informatique
  j.official_status = OfficialStatus.first
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
  j.contract_type = ContractType.first
  j.contract_start_on = Date.new(2019, 1, 1)
  j.is_remote_possible = false
  j.study_level = StudyLevel.last
  j.experience_level = ExperienceLevel.last
  j.sector = Sector.first
  j.is_negotiable = true
  j.estimate_monthly_salary_net = "2500 - 3000€"
  j.estimate_monthly_salary_gross = "39000 - 46000€"
  j.option_cover_letter = :mandatory
  j.option_resume = :mandatory
  j.option_portfolio_url = :optional
  j.option_photo = :optional
  j.option_website_url = :optional
  j.option_linkedin_url = :optional
end
job_offer.save!

job_offer2 = job_offer.dup
job_offer2.title = 'Conducteur d’Opérations (H/F)'
job_offer2.category = infrastructure
job_offer2.identifier = nil
job_offer2.sequential_id = nil
job_offer2.save!

job_offer3 = job_offer.dup
job_offer3.title = 'Responsable Achat d’Infrastructures (H/F)'
job_offer3.category = infrastructure
job_offer3.location = "Brest, FR"
job_offer3.identifier = nil
job_offer3.sequential_id = nil
job_offer3.save!

job_offer.publish!
job_offer2.publish!
job_offer3.publish!
