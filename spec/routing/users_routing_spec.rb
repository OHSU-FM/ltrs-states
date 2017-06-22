require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show via GET' do
      expect(:get => '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #ldap_search via GET as JSON' do
      expect(:get => 'ldap_search.json?q=1').to route_to('users#ldap_search',
                                                         format: 'json',
                                                         q: '1')
    end
  end
end
