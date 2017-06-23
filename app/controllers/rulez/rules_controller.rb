require_dependency "rulez/application_controller"

module Rulez

  # 
  # The rules controller
  # 
  class RulesController < ApplicationController

    # GET /rules
    def index
      @rules = Rule.all
    end

    # GET /rules/1
    def show
      set_rule
    end

    # GET /rules/new
    def new
      @rule = Rule.new
      set_contexts
    end

    # GET /rules/1/edit
    def edit
      set_rule
      set_contexts
    end

    # POST /rules
    def create
      logger.debug "======#{req_param}======"
      logger.debug "======#{req_param[:rule]}======"  
      set_contexts
      @rule = Rule.new(req_param[:rule])
      if @rule.save
        errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this create operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
        Engine::info_log("Rule #{@rule.name} was successfully created!")
        redirect_to @rule, notice: "Rule #{@rule.name} was successfully created.", alert: err_msg
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /rules/1
    def update
      logger.debug "======#{req_param}======"
      logger.debug "======#{req_param[:rule]}======"
      set_rule
      set_contexts
      if @rule.update_attributes(req_param[:rule])
        errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this edit operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
        Engine::info_log("Rule #{@rule.name} was successfully updated!")
        redirect_to @rule, notice: "Rule #{@rule.name} was successfully updated.", alert: err_msg
      else
        render action: 'edit'
      end
    end

    # DELETE /rules/1
    def destroy
      set_rule
      @rule.destroy
      respond_to do |format|
        format.html do
          errors = Rulez::doctor
          err_msg = nil
          if !errors.empty?
            err_msg = 'Due to this delete operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
          end
          redirect_to rules_url, notice: 'Rule was successfully destroyed.', alert: err_msg
        end
        format.json { render json: "{\"response\" : \"OK\"}" }
      end
    end

    # 
    # Sort the alternatives priority.
    # This action is called in ajax.
    # 
    # The request is made passing the parameter `:order` that is an array containing 
    # the alternative ids ordered by priority
    # 
    # example:
    # 
    # order: [3,12,5,4] # alt. 3 has priority 1 (highest), alt. 12 has priority 2 etc...
    # 
    def sort_alternatives
      set_rule
      new_order = params[:order].split(',').each { |e| e.slice! "alternative" }.map{ |e| e.to_i }
      old_order = @rule.alternatives.map { |e| e.id }

      #checks if all the alternatives referenced by params are the same found in current rule
      if (new_order - old_order).empty? && (old_order - new_order).empty?
        i = 1
        new_order.each do |aid|
          alternative = Alternative.find(aid)
          alternative.priority = i
          alternative.save
          i += 1
        end
        render json: "{\"response\" : \"OK\"}"
      else
        render json: "{\"response\" : \"ERROR: the alternatives provided does not belong to the given rule\"}"
      end
    end

    private

      # 
      # Set the current rule
      # 
      # @return [Rule] the current rule
      def set_rule
        @rule ||= Rule.find(params[:id])
      end


      # 
      # Return all the contexts
      # 
      # @return [Array] An array containing all the contexts
      def set_contexts
        @contexts ||= Context.all
      end

      def req_param
        params.require(:rule).permit(:description, :name, :rule, :context_id, :parameters)
      end
  end
end
