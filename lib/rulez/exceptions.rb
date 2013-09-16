module Rulez
  # General Rulez error
  class Error < StandardError; end

  # Target not set error
  class TargetMissing < Error; end

  # Parameters are not correct
  class WrongParameters < Error; end

  # Rule to evaluate not found
  class RuleMissing < Error; end

  # Function in parsing not setted in methods class
  class FunctionMissing < Error; end

  # Variable in parsing not found
  class VariableMissing < Error; end
end