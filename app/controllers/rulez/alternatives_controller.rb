require_dependency "rulez/application_controller"

module Rulez
  class AlternativesController < ApplicationController
    before_action :set_alternative, only: [:show, :edit, :update, :destroy]

    # GET /alternatives
    def index
      @alternatives = Alternative.all
    end

    # GET /alternatives/1
    def show
    end

    # GET /alternatives/new
    def new
      @alternative = Alternative.new
    end

    # GET /alternatives/1/edit
    def edit
    end

    # POST /alternatives
    def create
      @alternative = Alternative.new(alternative_params)

      if @alternative.save
        redirect_to @alternative, notice: 'Alternative was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /alternatives/1
    def update
      if @alternative.update(alternative_params)
        redirect_to @alternative, notice: 'Alternative was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /alternatives/1
    def destroy
      @alternative.destroy
      redirect_to alternatives_url, notice: 'Alternative was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_alternative
        @alternative = Alternative.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def alternative_params
        params.require(:alternative).permit(:description, :condition, :alternative)
      end
  end
end
