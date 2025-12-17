# frozen_string_literal: true

module Maintenance
  class MigrateJobApplicationFileTypeKindsTask < MaintenanceTasks::Task
    JAFT = {
      "822c87f5-096c-4805-a344-26fa4a7c1a06" => :employer_provided, # "Fiche d'agrément", "admin_only"
      "249cf8e5-34c9-4210-8697-24f8166d18d1" => :employer_provided, # "Proposition salariale à signer par le candidat", "template"
      "36aa90ee-3431-4eff-bd0d-f7ab3b9400bf" => :employer_provided, # "Arrêté du 4 mai 1988", "template"
      "14af7c55-ffdb-4a6e-89b2-532def672405" => :employer_provided, # "Guide ICT/TCT", "template"
      "c316a36c-8579-479f-b01b-f8bfd774b94a" => :employer_provided, # "Fiche de poste", "admin_only"
      "4088a171-ffe3-40d2-a013-4c1781d64268" => :manager_provided, # "Contrat", "template"
      "46769401-af7e-42a4-b657-389c487b1dc9" => :applicant_provided, # "Arrêté de détachement de l'administration d'origine", "template"
      "d22929e0-0da4-4846-a79a-d11f1797df99" => :manager_provided # "Formulaire \"Prise en charge transport\" à compléter", "template"
    }
    def collection = JobApplicationFileType.where(id: JAFT.keys)

    def process(element) = element.update!(kind: JAFT[element.id])
  end
end
