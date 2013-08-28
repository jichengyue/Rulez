require 'rulez_methods'

module Dummy
  class Application < Rails::Application
    config.after_initialize do
      
      #set methods class here
      Rulez.set_methods_class(RulezMethods::Methods)

      #set models here
      Dir[Rails.root + "app/models/**/*.rb"].each do |path|
        require path
      end
      Rulez.set_models(ActiveRecord::Base.send :descendants)

    end
  end
end
