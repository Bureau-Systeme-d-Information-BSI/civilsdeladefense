# frozen_string_literal: true

# Custom exception to handle the case where job application was available
# and was later archived or unpublished
class JobOfferNotAvailableAnymore < StandardError
  attr_accessor :data

  def initialize(data)
    super(data)
    @data = data
  end
end
