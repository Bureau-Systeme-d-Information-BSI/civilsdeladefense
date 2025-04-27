module AdministratorsHelper
  def roles(administrator)
    administrator.roles.map { |role| I18n.t("activerecord.attributes.administrator/roles.#{role}") }.to_sentence
  end
end
