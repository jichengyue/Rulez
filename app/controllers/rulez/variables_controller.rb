require_dependency "rulez/application_controller"

module Rulez
  class VariablesController < ApplicationController
    
    # GET /variables
    def index
      @variables = Variable.all
    end

    # GET /variables/1
    def show
      set_variable
    end

    # GET /variables/new
    def new
      @variable = Variable.new
      set_models
    end

    # GET /variables/1/edit
    def edit
      set_variable
      set_models
    end

    # POST /variables
    def create
      @variable = Variable.new(params[:variable])
      set_models
      if @variable.save
        redirect_to @variable, notice: 'Variable was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /variables/1
    def update
      set_variable
      set_models
      if @variable.update_attributes(params[:variable])
        redirect_to @variable, notice: 'Variable was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /variables/1
    def destroy
      set_variable
      @variable.destroy
      redirect_to variables_url, notice: 'Variable was successfully destroyed.'
    end

    private
      
      # 
      # Set the current variable
      # 
      # @return [Variable] the current variable
      def set_variable
        @variable = Variable.find(params[:id])
      end

      # 
      # Set the available models
      # 
      # @return [Array] the array of models available
      def set_models
        @models = Rulez::get_models
      end
  end
end
