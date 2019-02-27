class JobOfferNotAvailableAnymore < StandardError
  attr_accessor :data
  def initialize(data)
    @data = data
  end
end
