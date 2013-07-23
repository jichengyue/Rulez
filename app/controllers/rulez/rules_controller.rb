require_dependency "rulez/application_controller"

module Rulez
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
        redirect_to @rule, notice: 'Rule was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /rules/1
    def update
      set_rule
      set_contexts

      if @rule.update_attributes(params[:rule])
        redirect_to @rule, notice: 'Rule was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /rules/1
    def destroy
      set_rule
      @rule.destroy
      redirect_to rules_url, notice: 'Rule was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_rule
        @rule ||= Rule.find(params[:id])
      end

      def set_contexts
        @contexts ||= Context.all
      end
  end
end
