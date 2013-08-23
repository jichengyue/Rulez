require_dependency "rulez/application_controller"

module Rulez
  class AlternativesController < ApplicationController
    before_filter :set_rule

    # GET /alternatives/new
    def new
      @alternative = @rule.alternatives.new
    end

    # GET /alternatives/1/edit
    def edit
      set_alternative
    end

    # POST /alternatives
    def create
      @alternative = @rule.alternatives.new(params[:alternative])
      @alternative.priority = @rule.alternatives.length

      if @alternative.save
        redirect_to @rule, notice: 'Alternative was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /alternatives/1
    def update
      set_alternative
      if @alternative.update_attributes(params[:alternative])
        redirect_to @rule, notice: 'Alternative was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /alternatives/1
    def destroy
      set_alternative
      @alternative.destroy
      redirect_to rule_path(@rule), notice: 'Alternative was successfully destroyed.'
    end

    private

      # 
      # Set current rule
      # 
      # @return [type] [description]
      def set_rule
        @rule ||= Rule.find(params[:rule_id])
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_alternative
        @alternative = @rule.alternatives.find(params[:id])
      end
  end
end