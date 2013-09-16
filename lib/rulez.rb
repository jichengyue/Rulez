require "rulez/engine"

module Rulez
  @@methods_class = nil
  @@models = nil

  # 
  # Set the methods class: a class that contains all the methods
  # that are wanted to be referenceable and evaluable from the rules.
  # 
  # @param c [Class] The methods class
  # 
  # @return [Class] The methods class
  def self.set_methods_class(c)
    if c.class == Class
      Engine::debug_log("Methods class set: #{c}")
      @@methods_class = c
    else
      Engine::fatal_log("Methods class set: parameter is not a class!")
      raise Rulez::WrongParametersError, 'Parameter should be a class'
    end
  end


  # 
  # Get the methods class.
  # 
  # @return [Class] the methods class
  def self.get_methods_class
    if @@methods_class
      @@methods_class
    else
      Engine::fatal_log("Methods class get: class is not present!")
      raise Rulez::FunctionMissingError, 'Init error, methods class is not present.'
    end
  end
  
  # 
  # Set the models of the application.
  # @param  models [Array] the array of models
  # 
  # @return [Array] the array of models
  def self.set_models(models)
    if models.class == Array
      models.each do |m|
        if !(m < ActiveRecord::Base)
          Engine::fatal_log("Models set: one member is not a model!")
          raise Rulez::Error, 'Found a member of the array that is not a model'
        end
      end
      @@models = models
    else
      Engine::fatal_log("Models set: parameter is not an array!")
      raise Rulez::WrongParametersError, 'Parameter should be an Array'
    end
  end

  # 
  # Get the models of the application.
  # 
  # @return [Array] the array of models
  def self.get_models
    if @@models
      @@models
    else
      Engine::fatal_log("Models get: models not initialized!")
      raise Rulez::Error, 'Init error, models not initialized'
    end
  end

end
