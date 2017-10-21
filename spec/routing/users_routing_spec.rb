require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #users_search via GET' do
      expect(:get => '/users_search').to route_to('users#search')
    end

    it 'routes to #show via GET' do
      expect(:get => '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #travel_profile via GET' do
      expect(:get => '/users/1/travel_profile').to route_to('users#travel_profile', user_id: '1')
    end
  end
end
