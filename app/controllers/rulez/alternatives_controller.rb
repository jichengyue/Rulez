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
      i = 1
      @rule.alternatives.sort{|a,b| a.priority <=> b.priority}.each do |alternative|
        alternative.priority = i
        alternative.save
        i += 1
      end

      @alternative = @rule.alternatives.new(req_param[:alternative])
      @alternative.priority = i

      if @alternative.save
        errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this create operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
        redirect_to @rule, notice: 'Alternative was successfully created.', alert: err_msg
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /alternatives/1
    def update
      set_alternative
      if @alternative.update_attributes(req_param[:alternative])
        errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this edit operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
        redirect_to @rule, notice: 'Alternative was successfully updated.', alert: err_msg
      else
        render action: 'edit'
      end
    end

    # DELETE /alternatives/1
    def destroy
      set_alternative
      @alternative.destroy
      i = 1
      @rule.alternatives.sort{|a,b| a.priority <=> b.priority}.each do |alternative|
        if alternative.id != @alternative.id
          alternative.priority = i
          alternative.save
          i += 1
        end
      end
      errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this delete operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
      redirect_to rule_path(@rule), notice: 'Alternative was successfully destroyed.', alert: err_msg
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

      def req_param
        params.require(:alternative).permit(:description, :condition, :alternative)
      end
  end
end
