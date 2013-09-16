module Rulez
  # General Rulez error
  class Error < StandardError; end

  # Target not set error
  class TargetMissingError < Error; end

  # Parameters are not correct
  class WrongParametersError < Error; end

  # Rule to evaluate not found
  class RuleMissingError < Error; end

  # Function in parsing not setted in methods class
  class FunctionMissingError < Error; end

  # Variable in parsing not found
  class VariableMissingError < Error; end
end