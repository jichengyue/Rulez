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
      @functions = Rulez::get_methods_class.methods(false).map { |e| e.to_s }
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
      @context = Context.new(req_param[:context])

      if @context.save
        errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this create operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
        redirect_to @context, notice: 'Context was successfully created.', alert: err_msg
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /contexts/1
    def update
      set_context
      if @context.update_attributes(req_param[:context])
        errors = Rulez::doctor
        err_msg = nil
        if !errors.empty?
          err_msg = 'Due to this edit operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
        end
        redirect_to @context, notice: 'Context was successfully updated.', alert: err_msg
      else
        render action: 'edit'
      end
    end

    # DELETE /contexts/1
    def destroy
      set_context
      @context.destroy
      errors = Rulez::doctor
      err_msg = nil
      if !errors.empty?
        err_msg = 'Due to this delete operation some inconsistencies have been created. Go to DashBoard and Run Doctor to fix them.'
      end
      redirect_to contexts_url, notice: 'Context was successfully destroyed.', alert: err_msg
    end

    private
      # 
      # Set the @context variable, from the given id
      # 
      # @return [Context] the current context
      def set_context
        @context = Context.find(params[:id])
      end

      def req_param
        params.require(:context).permit(:description, :name, :variable_ids)
      end
  end
end
