class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :rulez?

  private
    def rulez? rule
      return Rulez::rulez? rule
    end
end
