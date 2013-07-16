module Rulez
  class Engine < ::Rails::Engine
    isolate_namespace Rulez
  end

  class MiaClasse
    def self.saluta
      p "Ciao!!!"
    end
    @@var = 4
    def self.stampavar
      p "#{@@var}"
    end
  end
end
