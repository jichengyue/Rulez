# Rulez

Gestisce condizioni logiche configurabili lato web e valutabili lato codice.

L'idea è quella di avere un editor visuale di espressioni booleane, definite in una grammatica custom.

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

## Features

### Creare e gestire regole (lato web)
Il servizio offre un editor visuale delle regole lato web.

* L'utente può creare una nuova regola. In fase di creazione viene chiesto di inserire:

  * un nome per nuova regola, che la identificherà univocamente. (non modificabile lato web, altrimenti può capitare di valutare una regola che non esiste più perchè è stata rinominata).
  * il contesto a cui la regola viene applicata. (vedi la sezione **Contesti**)
  * una descrizione esaustiva sul significato della regola e su quando va applicata.

* L'utente può modificare una regola appena creata o già esistente. La modifica avviene scrivendo all'interno di un campo testuale, con l'aiuto di un intelli-sense
  * L'intelli-sense aiuta l'utente passo per passo, dicendogli cosa si aspetta il parser in ogni determinato istante.
  * L'utente può inserire (nei limiti della corretta sintassi): operatori, operandi, espressioni, variabili, funzioni.
  * Le variabili e funzioni disponibili all'utente dipendono dal contesto e vengono suggerite volta per volta.

### Applicare le regole (lato codice)
Per valutare una regola, basta richiamarla utilizzando la funzione `rulez` definita dalla gemma e il nome della regola definita in fase di creazione

  Esempio: viene definita la regola `create_new_users` che definisce la possibilità di creare nuovi utenti.
  Per valutarla nel codice basterà eseguire una cosa del tipo `if rulez create_new_users ... else ... end`

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