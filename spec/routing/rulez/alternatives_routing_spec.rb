require "spec_helper"

module Rulez
  describe AlternativesController do

    # Load engine routes
    routes{Rulez::Engine.routes}

    describe "routing" do
  
      it "routes to #new" do
        get("rules/1/alternatives/new").should route_to("rulez/alternatives#new", rule_id: "1")
      end
  
      it "routes to #edit" do
        get("rules/1/alternatives/1/edit").should route_to("rulez/alternatives#edit", :id => "1", rule_id: "1")
      end
  
      it "routes to #create" do
        post("rules/1/alternatives").should route_to("rulez/alternatives#create", rule_id: "1")
      end
  
      it "routes to #update" do
        put("rules/1/alternatives/1").should route_to("rulez/alternatives#update", :id => "1", rule_id: "1")
      end
  
      it "routes to #destroy" do
        delete("rules/1/alternatives/1").should route_to("rulez/alternatives#destroy", :id => "1", rule_id: "1")
      end
  
    end
  end
end
