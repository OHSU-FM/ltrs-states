require "rails_helper"

RSpec.describe TravelRequestsController, type: :routing do
  describe "routing" do

    # actually a redirect
    it "routes to #index" do
      expect(:get => "/travel_requests").to route_to("travel_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/travel_requests/new").to route_to("travel_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/travel_requests/1").to route_to("travel_requests#show", :id => "1")
    end

    it "doesn't route to #edit" do
      expect(:get => "/travel_requests/1/edit").not_to route_to("travel_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/travel_requests").to route_to("travel_requests#create")
    end

    it "doesn't route to #update via PUT" do
      expect(:put => "/travel_requests/1").not_to route_to("travel_requests#update", :id => "1")
    end

    it "doesn't route to #update via PATCH" do
      expect(:patch => "/travel_requests/1").not_to route_to("travel_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/travel_requests/1").to route_to("travel_requests#destroy", :id => "1")
    end

    it "routes to #submit bia POST" do
      expect(:post => "/travel_requests/1/submit").to route_to("travel_requests#submit", :id => "1")
    end

    it "doesn't route to #send_to_unopened via POST" do
      expect(:post=> "/travel_requests/1/send_to_unopened").not_to route_to("travel_requests#send_to_unopened", :id => "1")
    end

    it "routes to #review via POST" do
      expect(:post=> "/travel_requests/1/review").to route_to("travel_requests#review", :id => "1")
    end

    it "routes to #reject via POST" do
      expect(:post=> "/travel_requests/1/reject").to route_to("travel_requests#reject", :id => "1")
    end

    it "routes to #accept via POST" do
      expect(:post=> "/travel_requests/1/accept").to route_to("travel_requests#accept", :id => "1")
    end
  end
end
