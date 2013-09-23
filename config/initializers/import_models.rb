require 'rulez_methods'

module Rulez
  # sets the models
  Dir[Rails.root + "app/models/**/*.rb"].each do |path|
    require path
  end
  Rulez.set_models(ActiveRecord::Base.send :descendants)
end
