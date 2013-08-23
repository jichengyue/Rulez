require_dependency "rulez/application_controller"

module Rulez

  # 
  # The Contexts Controller
  # 
  class ContextsController < ApplicationController

    # GET /contexts
    def index
      @contexts = Context.all
    end

    # GET /contexts/1
    def show
      set_context
    end

    # 
    # Renders the available variables for a given context.
    # This action is called in Ajax from other views
    # 
    def variables
      set_context
      @variables = @context.variables
      @methods = Rulez::get_methods_class.methods(false).map { |e| e.to_s }
      render layout: false
    end

    # GET /contexts/new
    def new
      @context = Context.new
    end

    # GET /contexts/1/edit
    def edit
      set_context
    end

    # POST /contexts
    def create
      @context = Context.new(params[:context])

      if @context.save
        redirect_to @context, notice: 'Context was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /contexts/1
    def update
      set_context
      if @context.update_attributes(params[:context])
        redirect_to @context, notice: 'Context was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /contexts/1
    def destroy
      set_context
      @context.destroy
      redirect_to contexts_url, notice: 'Context was successfully destroyed.'
    end

    private
      # 
      # Set the @context variable, from the given id
      # 
      # @return [Context] the current context
      def set_context
        @context = Context.find(params[:id])
      end
  end
end
