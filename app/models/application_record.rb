# frozen_string_literal: true

# Rails root AR class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
