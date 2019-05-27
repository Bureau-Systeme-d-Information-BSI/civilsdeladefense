# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobOffersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/offresdemploi').to route_to('job_offers#index')
    end

    it 'routes to #show' do
      expect(get: '/offresdemploi/1').to route_to('job_offers#show', id: '1')
    end
  end
end
