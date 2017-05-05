require "rails_helper"

RSpec.describe LeaveRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/leave_requests").to route_to("leave_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/leave_requests/new").to route_to("leave_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/leave_requests/1").to route_to("leave_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/leave_requests/1/edit").to route_to("leave_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/leave_requests").to route_to("leave_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/leave_requests/1").to route_to("leave_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/leave_requests/1").to route_to("leave_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/leave_requests/1").to route_to("leave_requests#destroy", :id => "1")
    end

  end
end
