# Rulez

Rulez is a business rule engine that makes possible to easily create logical conditions and evaluate them in the code.

It provides a web editor of boolean expressions, defined with a grammar.

## Features

### Creating and managing rules (web-based)
The engine provides a visual web-based editor for the rules.

* The user can create a new rule. When creating, it's prompted to enter:
  * An identifying *name* for the rule. It must be unique. It's important to choose carefully the name: once the rule is evaluated by code, renaming the rule may result in strings of code that reference to a non-existing rule.
  * An exhaustive *description* about the meaning of the rule and about when is to be applied
  * Some *parameters* (like the parameters of a function). If any, they must be declared writing down their names separated by comma.
  * The *context* in which the rule will be applied. (see the **Contexts** section)
  * The real *rule*. It's a boolean expression, whose result indicates whether or not the rule will enable the behaviour that you are trying to describe. (For further instructions, see the **Rule syntax** section)

### Applying the rules (code-side)
* For evaluating a rule (without paramters), just call the function `rulez?` with a string containing the name of the rule.
  E.g.: An administrator defines a rule, named `create_new_users`, that describes the possibility to create new users.
  If you want to evaluate it in the code, you just have to write:
  ```ruby
  if rulez? 'create_new_users' do
    # inner_code
  end
  ```
  This will executes `inner_code` only if the rule succeeds.

* For evaluating a rule with parameters, you can pass them to the rule in a hash:
  E.g.: An administrator defines a rule, named `use_advanced_tool_X`, that describes the possibility to use the advanced tool "X".
  Since the rule has a different behaviour if the user is a premium user, the rule is defined with a boolean parameter `premium`.
  For evaluating the rule, you have to pass to `rulez?` a value for that parameter, using a hash:
  ```ruby
  if rulez? 'use_advanced_tool_X' {premium: true} do
    # inner_code
  end
  ```
  This will executes `inner_code` only if the rule succeeds.



### Contesti
La gemma permette di definire dei contesti all'interno dei quali è garantita la presenza di alcune variabili.

Un `context` prevede:
* nome: univoco, identificativo
* descrizione: anche lunga, deve spiegare che cos'è questo contesto, dove è definito e utilizzato all'interno dell'applicazione
* variabili: una serie di variabili che saranno utilizzabili nell'editor visuale. Ognuna di esse ha:
  * nome: univoco nel contesto, identificativo, sarà quello visualizzato nell'editor
  * code_name: il nome reale della variabile, serve per eseguire il binding dalla grammatica custom a ruby
  * type: indica il tipo della variabile
* funzioni: una serie di funzioni che saranno utilizzabili nell'editor visuale. Ognuna di esse ha:
  * nome: univoco nel contesto, identificativo, sarà quello visualizzato nell'editor
  * description: descrive cosa fa la funzione
  * type: indica il tipo che ritorna la funzione
  * code_name: il nome reale della funzione, serve per eseguire il binding dalla grammatica custom a ruby.
  * Ogni funzione (con tutti i campi descritti sopra) viene definita automaticamente parsificando un file in cui sono implementate tutte le funzioni del contesto

## Definizione della grammatica

* Ogni regola `rule` è composta da un'espressione `expr` che ritorna un booleano
* Ogni `expr` è un gruppo `operand`-`operator`-`operand`
* Ogni `operand` può essere: `boolean`, `num`, `datetime`, `expr`, `var` o `func`
  * `var`: sono variabili rese disponibili dal contesto corrente (vedi la sezione **Contesti**)
  * `func`: sono funzioni custom rese disponibili dal contesto corrente (vedi la sezione **Contesti**)
* Lista degli `operator` validi:
  * >
  * <
  * >=
  * <=
  * !
  * &&
  * ||
  * ==
  * !=
  * +
  * -
  * *
  * /
  * %

## Configurazione

Gemfile:

```ruby
gem 'rulez'
```

eseguire da terminale:

```
bundle install
rake rulez:install:migrations
rake db:migrate
```

routes.rb:
```ruby
mount Rulez::Engine => "/rulez", as: 'rulez'
```

application_controller.rb:
```ruby
helper_method :rulez?
before_filter :set_rulez_target

private
  def rulez? rule
    return Rulez::rulez? rule
  end

  def set_rulez_target
    Rulez::set_rulez_target self
  end
```

in lib/ creare un file rulez_methods.rb dove verranno inseriti dei metodi statici utilizzabili all'interno delle rules
```ruby
module RulezMethods
  class Methods
    def self.thetruth
      true
    end
  end
end
```

in config/initializers creare un file rulez_methods_init.rb:
```ruby
require 'rulez_methods'

module <NomeApplicazione>
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
```

creare le regole lato web.

Per utilizzare le regole nel codice:

```ruby
if rulez? 'nomeregola'
  ...
end
```

### Rule syntax 