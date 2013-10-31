class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :rulez?
  before_filter :set_rulez_target, :last_restaurant, :first_restaurant

  private
    def rulez? rule, params = {}
      return Rulez::rulez? rule, params
    end

    def set_rulez_target
      Rulez::set_rulez_target self
    end

    def last_restaurant
      @last_restaurant ||= Restaurant.last
    end

    def first_restaurant
      @first_restaurant ||= Restaurant.first
    end 
end
