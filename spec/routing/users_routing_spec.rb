require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #ldap_search via GET' do
      expect(:get => '/ldap_search').to route_to('users#ldap_search')
    end

    it 'routes to #show via GET' do
      expect(:get => '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #travel_profile via GET' do
      expect(:get => '/users/1/travel_profile').to route_to('users#travel_profile', user_id: '1')
    end
  end
end
