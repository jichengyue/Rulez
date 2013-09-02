require_dependency "rulez/application_controller"

module Rulez
  class StaticController < ApplicationController

    # 
    # The rulez engine homepage
    # 
    def index
    end

    # 
    # flush the log file (tipically shoud be not used because of automatic write back
    # setting imposed on thet file).
    # 
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

    # 
    # Return the first n_rows of lines in the rulez log file depending on which kind of 
    # information the user has selected (FATAL, ERROR, WARNING, INFO, DEBUG) in json format.
    # 
    def displaylog
      respond_to do |format|
        format.json {
          filter = params[:checkbox_actives].map { |s| s.to_s }.join("|")
          nr = params[:n_rows]
          res = `grep -E -w \'#{filter}\' log/rulez.log | tail -n #{nr}`
          render json: res.split("\n").to_json
        }
      end
    end

  end
end