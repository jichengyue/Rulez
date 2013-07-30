require 'rulez_methods'

module Dummy
  class Application < Rails::Application
    config.after_initialize do
      #set methods class here
      Rulez.set_methods_class(RulezMethods::Methods)
    end
  end
end
