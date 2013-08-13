require_dependency "rulez/application_controller"

module Rulez
  class SymbolsController < ApplicationController
    
    # GET /symbols
    def index
      @symbols = Symbol.all
    end

    # GET /symbols/1
    def show
      set_symbol
    end

    # GET /symbols/new
    def new
      @symbol = Symbol.new
      set_models
    end

    # GET /symbols/1/edit
    def edit
      set_symbol
      set_models
    end

    # POST /symbols
    def create
      @symbol = Symbol.new(params[:symbol])
      set_models
      if @symbol.save
        redirect_to @symbol, notice: 'Symbol was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /symbols/1
    def update
      set_symbol
      set_models
      if @symbol.update_attributes(params[:symbol])
        redirect_to @symbol, notice: 'Symbol was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /symbols/1
    def destroy
      set_symbol
      @symbol.destroy
      redirect_to symbols_url, notice: 'Symbol was successfully destroyed.'
    end

    private
      
      # 
      # Set the current symbol
      # 
      # @return [Symbol] the current symbol
      def set_symbol
        @symbol = Symbol.find(params[:id])
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