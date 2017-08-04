require "rails_helper"

RSpec.describe ReimbursementRequestsController, type: :routing do
  describe "routing" do
    it "doesn't route to #index" do
      expect(:get => "/reimbursement_requests").not_to route_to("reimbursement_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/reimbursement_requests/new").to route_to("reimbursement_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/reimbursement_requests/1").to route_to("reimbursement_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reimbursement_requests/1/edit").to route_to("reimbursement_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reimbursement_requests").to route_to("reimbursement_requests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/reimbursement_requests/1").to route_to("reimbursement_requests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reimbursement_requests/1").to route_to("reimbursement_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reimbursement_requests/1").to route_to("reimbursement_requests#destroy", :id => "1")
    end

    it "routes to #submit bia POST" do
      expect(:post => "/reimbursement_requests/1/submit").to route_to("reimbursement_requests#submit", :id => "1")
    end

    it "doesn't route to #send_to_unopened via POST" do
      expect(:post=> "/reimbursement_requests/1/send_to_unopened").not_to route_to("reimbursement_requests#send_to_unopened", :id => "1")
    end

    it "routes to #review via POST" do
      expect(:post=> "/reimbursement_requests/1/review").to route_to("reimbursement_requests#review", :id => "1")
    end

    it "routes to #reject via POST" do
      expect(:post=> "/reimbursement_requests/1/reject").to route_to("reimbursement_requests#reject", :id => "1")
    end

    it "routes to #accept via POST" do
      expect(:post=> "/reimbursement_requests/1/accept").to route_to("reimbursement_requests#accept", :id => "1")
    end
  end
end
