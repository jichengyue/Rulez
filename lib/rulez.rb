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
      @@methods_class = c
      Engine::debug_log("Methods class set: #{c}")
    else
      Engine::fatal_log("Methods class set: parameter is not a class!")
      raise 'Parameter should be a class'
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
      raise 'Init error, methods class is not present.'
    end
  end
  
  # 
  # Set the models of the application.
  # @param  models [Array] the array of model names
  # 
  # @return [Array] the array of model names
  def self.set_models(models)
    if models.class == Array
      models.each do |m|
        if !(m < ActiveRecord::Base)
          Engine::fatal_log("Models set: one member is not a model!")
          raise 'Found a member of the array that is not a model'
        end
      end
      @@models = models
    else
      Engine::fatal_log("Models set: parameter is not an array!")
      raise 'Parameter should be an Array'
    end
  end

  def self.get_models
    if @@models
      @@models
    else
      Engine::fatal_log("Models get: models not initialized!")
      raise 'Init error, models not initialized'
    end
  end

end
