class Exporter::Administrator < Exporter::Base
  def fill_data
    fill_filters
    add_row
    add_row(
      "Prénom",
      "Nom",
      "Email",
      "Employeur",
      "État",
      "Role",
      "Date de création de compte",
      "Date de la dernière connexion",
      "Agent à l'origine de l'invitation",
      "Liste des offres"
    )
    data[:data].each do |line|
      add_row(format_user(line))
    end
  end

  def fill_filters
    add_row("Filtres")
    employer = Employer.find_by(id: data[:q][:employer_id_eq])
    add_row("Employeur", employer.name) if employer
    add_row("Nom", data[:q][:first_name_or_last_name_or_email_cont]) if data[:q][:first_name_or_last_name_or_email_cont]
    role = Administrator.roles.find { |name, id| id.to_s == data[:q][:role_eq] }
    add_row("Rôle", role.first) if role
  end

  def format_user(administrator)
    [
      administrator.first_name,
      administrator.last_name,
      administrator.email,
      administrator.employer.code,
      administrator.deleted_at ? "Actif" : "Inactif",
      Administrator.human_attribute_name("role.#{administrator.role}"),
      localize(administrator.created_at),
      localize(administrator.last_sign_in_at),
      administrator.inviter.full_name,
      administrator.owned_job_offers.map { |o| o.identifier }.join(", ")
    ]
  end
end
