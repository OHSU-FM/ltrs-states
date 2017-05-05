require "rails_helper"

RSpec.describe ApprovalStatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/approval_states").to route_to("approval_states#index")
    end

    it "routes to #new" do
      expect(:get => "/approval_states/new").to route_to("approval_states#new")
    end

    it "routes to #show" do
      expect(:get => "/approval_states/1").to route_to("approval_states#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/approval_states/1/edit").to route_to("approval_states#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/approval_states").to route_to("approval_states#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/approval_states/1").to route_to("approval_states#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/approval_states/1").to route_to("approval_states#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/approval_states/1").to route_to("approval_states#destroy", :id => "1")
    end

  end
end
