# frozen_string_literal: true

# Liste des Centre Ministériel de Gestion (CMG)
class Cmg < ApplicationRecord
  belongs_to :organization
end
