module AdministratorsHelper
  def actor_roles_or_general_role(administrator)
    if (actor_roles = administrator.job_offer_actors.pluck(:role).compact).any?
      actor_roles.uniq.map { |role| t("activerecord.attributes.job_offer_actor/role.#{role}") }.to_sentence
    elsif administrator.role
      t("activerecord.attributes.administrator/role.#{administrator.role}")
    end
  end
end
