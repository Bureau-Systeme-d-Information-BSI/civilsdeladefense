# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Settings::EmployersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/parametres/employers').to route_to('admin/settings/employers#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/parametres/employers/new').to route_to('admin/settings/employers#new')
    end

    it 'routes to #edit' do
      expect(get: '/admin/parametres/employers/1/edit').to route_to('admin/settings/employers#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/parametres/employers').to route_to('admin/settings/employers#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/parametres/employers/1').to route_to('admin/settings/employers#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/parametres/employers/1').to route_to('admin/settings/employers#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/parametres/employers/1').to route_to('admin/settings/employers#destroy', id: '1')
    end
  end
end
