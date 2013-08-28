require_dependency "rulez/application_controller"

module Rulez
  class StaticController < ApplicationController

    # 
    # The rulez engine homepage
    # 
    def index
    end

    def flush_log
      Rulez::Engine::flush_log
    end

    # 
    # Executes rulez doctor and returns html page with errors or success message
    # 
    def doctor
      @errors = Rulez::doctor
      @errors.each do |e|
        case e[:type]
        when "Variable"
          e[:show_path] = variable_path(e[:ref])
          e[:edit_path] = edit_variable_path(e[:ref])
          e[:destroy_path] = variable_path(e[:ref])
        when "Rule"
          e[:show_path] = rule_path(e[:ref])
          e[:edit_path] = edit_rule_path(e[:ref])
          e[:destroy_path] = rule_path(e[:ref])
        when "Alternative"
          e[:show_path] = rule_path(e[:ref].rule)
          e[:edit_path] = edit_rule_alternative_path(e[:ref].rule, e[:ref])
          e[:destroy_path] = rule_alternative_path(e[:ref].rule, e[:ref])
        end
      end
      render layout: false
    end

  end
end