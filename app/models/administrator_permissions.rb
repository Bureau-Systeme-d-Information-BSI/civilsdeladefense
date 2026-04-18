module AdministratorPermissions
  MATRIX = YAML.safe_load_file(
    Rails.root.join("config/administrator_permissions.yml"),
    permitted_classes: [Symbol]
  ).freeze

  def self.allows?(role:, state:, action:)
    value = MATRIX.dig(role.to_s, state.to_s, action.to_s)
    !value.nil? && value != false
  end

  def self.allows_state_transition?(role:, state:, target_state:)
    value = MATRIX.dig(role.to_s, state.to_s, "update_application_state")
    value.is_a?(Array) && value.include?(target_state.to_s)
  end
end
