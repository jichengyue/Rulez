require "rulez/engine"

module Rulez
  @@methods_class = nil

  def self.set_methods_class(c)
    if c.class == Class
      @@methods_class = c
    else
      raise 'Parameter should be a class'
    end
  end

  def self.get_methods_class
    @@methods_class
  end

end
