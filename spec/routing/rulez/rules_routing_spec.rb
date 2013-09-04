require "spec_helper"

module Rulez
  describe RulesController do
    describe "routing" do

      # load engine routes
      routes { Rulez::Engine.routes }

      it "routes to #index" do
        get("/rules").should route_to("rulez/rules#index")
      end

      it "routes to #new" do
        get("/rules/new").should route_to("rulez/rules#new")
      end

      it "routes to #show" do
        get("/rules/1").should route_to("rulez/rules#show", id: "1")
      end

      it "routes to #edit" do
        get("/rules/1/edit").should route_to("rulez/rules#edit", id: "1")
      end

      it "routes to #create" do
        post("/rules").should route_to("rulez/rules#create")
      end

      it "routes to #update" do
        put("/rules/1").should route_to("rulez/rules#update", id: "1")
      end

      it "routes to #destroy" do
        delete("/rules/1").should route_to("rulez/rules#destroy", id: "1")
      end

      it "routes to #sort_alternatives" do
        post("/rules/1/sort_alternatives").should route_to("rulez/rules#sort_alternatives", id: "1")
      end

    end
  end
end
