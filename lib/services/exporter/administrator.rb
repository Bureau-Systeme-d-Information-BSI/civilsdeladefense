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
      "Rôle",
      "Rôles sur les offres",
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
    employer = Employer.find_by(id: data[:q][:employer_id_eq]) if data.dig(:q, :employer_id_eq)
    add_row("Employeur", employer.name) if employer
    add_row("Nom", data[:q][:first_name_or_last_name_or_email_cont]) if data.dig(:q, :first_name_or_last_name_or_email_cont)
    if data.dig(:q, :role_eq)
      role = Administrator.roles.find { |name, id| id.to_s == data[:q][:role_eq] }
      add_row("Rôle", role.first) if role
    end
  end

  def format_user(administrator)
    [
      administrator.first_name,
      administrator.last_name,
      administrator.email,
      administrator.employer&.code,
      administrator.deleted_at ? "Actif" : "Inactif",
      role(administrator),
      actor_roles(administrator),
      localize(administrator.created_at),
      localize(administrator.last_sign_in_at),
      administrator.inviter&.full_name,
      administrator.owned_job_offers.map { |o| o.identifier }.join(", ")
    ]
  end

  def role(administrator)
    if administrator.role.present?
      Administrator.human_attribute_name("role.#{administrator.role}")
    else
      I18n.t("admin.settings.administrators.administrator.no_role")
    end
  end

  def actor_roles(administrator)
    administrator
      .job_offer_actors
      .pluck(:role)
      .compact
      .uniq
      .map { |role| I18n.t("activerecord.attributes.job_offer_actor/role.#{role}") }
      .to_sentence
  end
end
