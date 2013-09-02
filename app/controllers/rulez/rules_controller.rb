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
      @rule = Rule.new(params[:rule])
      set_contexts
      if @rule.save
        Engine::info_log("Rule #{@rule.name} was successfully created!")
        redirect_to @rule, notice: "Rule #{@rule.name} was successfully created."
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /rules/1
    def update
      set_rule
      set_contexts
      if @rule.update_attributes(params[:rule])
        Engine::info_log("Rule #{@rule.name} was successfully updated!")
        redirect_to @rule, notice: "Rule #{@rule.name} was successfully updated."
      else
        render action: 'edit'
      end
    end

    # DELETE /rules/1
    def destroy
      set_rule
      @rule.destroy
      respond_to do |format|
        format.html { redirect_to rules_url, notice: 'Rule was successfully destroyed.' }
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
      end

      render json: "{\"response\" : \"OK\"}"
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
  end
end
