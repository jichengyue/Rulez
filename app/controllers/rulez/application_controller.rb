module Rulez

  class ApplicationController < ActionController::Base
    before_filter :authenticate

    private

    # 
    # This method restricts the access to the administration tools of Rulez.
    # The authentication is performed evaluating a rule called "admin_rulez",
    # that is set to "true" by default.
    # 
    def authenticate
      Rulez::set_rulez_target self
      if request.path != accessdenied_path && !Rulez::rulez?("admin_rulez")
        redirect_to accessdenied_path
      end
    end
  end
end
