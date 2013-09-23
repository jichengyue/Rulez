module Rulez

  # sets the methods class
  if (path = Pathname.new(Rails.root + "lib/rulez_methods.rb")).exist?
    require path
    Rulez.set_methods_class(RulezMethods::Methods)
  else
    raise StandardError.new "Missing file: lib/rulez_methods.rb. Run rake rulez:install:methods"
  end

  # sets the models
  Dir[Rails.root + "app/models/**/*.rb"].each do |path|
    require path
  end
  Rulez.set_models(ActiveRecord::Base.send :descendants)
end
