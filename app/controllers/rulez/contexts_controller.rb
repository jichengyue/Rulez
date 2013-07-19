require_dependency "rulez/application_controller"

module Rulez
  class ContextsController < ApplicationController

    # GET /contexts
    def index
      @contexts = Context.all
    end

    # GET /contexts/1
    def show
      set_context
    end

    def symbols
      set_context
      @symbols = @context.symbols
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
      # Use callbacks to share common setup or constraints between actions.
      def set_context
        @context = Context.find(params[:id])
      end
  end
end
