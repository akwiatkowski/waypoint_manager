require "spec_helper"

describe RouteElementsController do
  describe "routing" do

    it "routes to #index" do
      get("/route_elements").should route_to("route_elements#index")
    end

    it "routes to #new" do
      get("/route_elements/new").should route_to("route_elements#new")
    end

    it "routes to #show" do
      get("/route_elements/1").should route_to("route_elements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/route_elements/1/edit").should route_to("route_elements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/route_elements").should route_to("route_elements#create")
    end

    it "routes to #update" do
      put("/route_elements/1").should route_to("route_elements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/route_elements/1").should route_to("route_elements#destroy", :id => "1")
    end

  end
end
