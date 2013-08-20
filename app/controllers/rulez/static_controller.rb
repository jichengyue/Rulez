require_dependency "rulez/application_controller"

module Rulez
  class StaticController < ApplicationController

    # 
    # The rulez engine homepage
    # 
    def index
    end

    # 
    # Executes rulez doctor and returns html page with errors or success message
    # 
    def doctor
      @errors = Rulez::doctor
      render layout: false
    end

  end
end