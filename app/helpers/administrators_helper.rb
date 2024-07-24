module AdministratorsHelper
  def actor_roles_or_general_role(administrator)
    if (actor_roles = actor_roles(administrator)).present?
      actor_roles
    elsif administrator.role
      t("activerecord.attributes.administrator/role.#{administrator.role}")
    end
  end

  def actor_roles(administrator)
    administrator
      .job_offer_actors
      .pluck(:role)
      .compact
      .uniq
      .map { |role| t("activerecord.attributes.job_offer_actor/role.#{role}") }
      .to_sentence
  end
end
