require "spec_helper"

module Rulez
  describe StaticController do
    describe "routing" do
      
      # load engine routes
      routes { Rulez::Engine.routes }

      it "routes to #index" do
        get("/").should route_to("rulez/static#index")
      end

      it "routes to #doctor" do
        get("/doctor").should route_to("rulez/static#doctor")
      end

      it "routes to #displaylog" do
        get("/displaylog").should route_to("rulez/static#displaylog")
      end

      it "routes to #clearlogfile" do
        get("/clearlogfile").should route_to("rulez/static#clearlogfile")
      end

    end
  end
end