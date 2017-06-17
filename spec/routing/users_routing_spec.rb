require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes #show' do
      expect(:get => '/users/1').to route_to('users#show', id: '1')
    end
  end
end
