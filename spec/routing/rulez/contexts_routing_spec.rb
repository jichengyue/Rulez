require "spec_helper"

module Rulez
  describe ContextsController do
    describe "routing" do

      #load engine routes
      routes { Rulez::Engine.routes }
  
      it "routes to #index" do
        get("/contexts").should route_to("rulez/contexts#index")
      end
  
      it "routes to #new" do
        get("/contexts/new").should route_to("rulez/contexts#new")
      end
  
      it "routes to #show" do
        get("/contexts/1").should route_to("rulez/contexts#show", id: "1")
      end
  
      it "routes to #edit" do
        get("/contexts/1/edit").should route_to("rulez/contexts#edit", id: "1")
      end
  
      it "routes to #create" do
        post("/contexts").should route_to("rulez/contexts#create")
      end
  
      it "routes to #update" do
        put("/contexts/1").should route_to("rulez/contexts#update", id: "1")
      end
  
      it "routes to #destroy" do
        delete("/contexts/1").should route_to("rulez/contexts#destroy", id: "1")
      end

      it "routes to #variables" do
        get("/contexts/1/variables").should route_to("rulez/contexts#variables", id: "1")
      end
  
    end
  end
end
