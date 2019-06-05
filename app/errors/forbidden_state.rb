# frozen_string_literal: true

# Custom exception to handle the case where job application was available
# and was later archived or unpublished
class ForbiddenState < StandardError
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def error_message
    "State #{data[:state]} is not a known state"
  end
end
