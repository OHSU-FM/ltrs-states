require "rails_helper"

RSpec.describe TravelRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/travel_requests").to route_to("travel_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/travel_requests/new").to route_to("travel_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/travel_requests/1").to route_to("travel_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/travel_requests/1/edit").to route_to("travel_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/travel_requests").to route_to("travel_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/travel_requests/1").to route_to("travel_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/travel_requests/1").to route_to("travel_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/travel_requests/1").to route_to("travel_requests#destroy", :id => "1")
    end

  end
end
