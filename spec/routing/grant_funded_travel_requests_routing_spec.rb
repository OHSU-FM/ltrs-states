require "rails_helper"

RSpec.describe GrantFundedTravelRequestsController, type: :routing do
  describe "routing" do

    it "doesn't route to #index" do
      expect(:get => "/grant_funded_travel_requests").not_to route_to("grant_funded_travel_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/grant_funded_travel_requests/new").to route_to("grant_funded_travel_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/grant_funded_travel_requests/1").to route_to("grant_funded_travel_requests#show", :id => "1")
    end

    it "doesn't route to #edit" do
      expect(:get => "/grant_funded_travel_requests/1/edit").not_to route_to("grant_funded_travel_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/grant_funded_travel_requests").to route_to("grant_funded_travel_requests#create")
    end

    it "doesn't route to #update via PUT" do
      expect(:put => "/grant_funded_travel_requests/1").not_to route_to("grant_funded_travel_requests#update", :id => "1")
    end

    it "doesn't route to #update via PATCH" do
      expect(:patch => "/grant_funded_travel_requests/1").not_to route_to("grant_funded_travel_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/grant_funded_travel_requests/1").to route_to("grant_funded_travel_requests#destroy", :id => "1")
    end

    it "routes to #submit bia POST" do
      expect(:post => "/grant_funded_travel_requests/1/submit").to route_to("grant_funded_travel_requests#submit", :id => "1")
    end

    it "routes to #send_to_unopened via POST" do
      expect(:post=> "/grant_funded_travel_requests/1/send_to_unopened").to route_to("grant_funded_travel_requests#send_to_unopened", :id => "1")
    end

    it "routes to #review via POST" do
      expect(:post=> "/grant_funded_travel_requests/1/review").to route_to("grant_funded_travel_requests#review", :id => "1")
    end

    it "routes to #reject via POST" do
      expect(:post=> "/grant_funded_travel_requests/1/reject").to route_to("grant_funded_travel_requests#reject", :id => "1")
    end

    it "routes to #accept via POST" do
      expect(:post=> "/grant_funded_travel_requests/1/accept").to route_to("grant_funded_travel_requests#accept", :id => "1")
    end
  end
end
