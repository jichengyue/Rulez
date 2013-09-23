# Rulez

Rulez is a business rule engine that makes possible to easily create logical conditions and evaluate them in the code.

It provides also a web editor for the rules, that are stored in DB and can thus be modified at run-time.

## Getting started

### 1. Configuration

Gemfile:
```ruby
gem 'rulez'
```

routes.rb:
```ruby
mount Rulez::Engine => "/rulez", as: 'rulez'
```

application_controller.rb:
```ruby
before_filter :set_rulez_target

private
  def set_rulez_target
    Rulez::set_rulez_target self
  end
```

Run from terminal:
```
bundle install
```

### 2. Installation
* Full install - includes: migrations, log environment, rulez methods
  
  ```
  rake rulez:install:full
  rake db:migrate
  ```
* Custom install
  * Migrations:
    
    ```
    rake rulez:install:migrations
    rake db:migrate
    ```

  * Log environment:
   
    ```
    rake rulez:install:log_env
    ```
  
  * Rulez methods:
    
    ```
    rake rulez:install:methods
    ```
  
  * Spec:
    
    ```
    rake rulez:install:test
    ```
    This task install a rspec test that automatically runs the **Doctor** when testing the application. (See Doctor section).
    **NB:** this task is NOT automatically installed by the full install.

### 3. Setting up the environment
* Define methods TODO

### 4. Using the gem
The business rules can be created using the web editor at the engine path (default is "/rulez") 

For evaluating the created rules in the code:
* without parameters:
  ```ruby
  if rulez? 'rulename'
    ...
  end
  ```
* with parameters:
  ```ruby
  if rulez? 'rulename' {param1: value1, param2: value2, param3: value3}
    ...
  end
  ```

## Features

### Creating and managing rules (web-based)
The engine provides a visual web-based editor for the rules.

* The user can create a new rule. When creating, it's prompted to enter:
  * An identifier **name** for the rule. It must be unique. It's important to choose carefully the name: once the rule is evaluated by code, renaming the rule may result in strings of code that reference to a non-existing rule.
  * An exhaustive **description** about the meaning of the rule and about when is to be applied
  * Some **parameters** (like the parameters of a function). If any, they must be declared writing down their names separated by comma.
  * The *context* in which the rule will be applied. (see the **Contexts** section)
  * The real *rule*. It's a boolean expression, whose result indicates whether or not the rule will enable the behaviour that you are trying to describe. (For further instructions, see the **Rule syntax** section)

### Applying a rule (code-side)
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

### Contexts
Contexts are the core of the engine. They abstractly define some areas of code in which the presence of some variables is guaranteed by the developers.

Each rule is always defined in a given context. The context *obliges* those who create the rule to use only the variables authorized (and guaranteed) from it.

Before creating any rule, it's mandatory to define at least one context.

When creating a context, it's prompted to enter:
* An identifier **name**. It must be unique.
* An exhaustive (and also long) **description**. It must explain what's this context, where it is defined and when it's used in the application.
* A set of **variables** (selected from a list of existent variables. See the **Variables** section). Select a variable means *ensuring* that it will be ever available when evaluating a rule belonging to this context.

### Variables
A variable is, simply, a variable usable by a rule.

To make a variable referenceable by a rule, the rule must belong to a context that contains that variable.

When creating a `variable`, it's prompted to enter:
* A unique identifier **name**. This name identifies both the variable (instance of the Model named "Variable") and the ruby variable (that is present in the code) that will be matched during the evaluation.
* An exhaustive **description** for the variable.
* A **Model**. This works as a Type for the variable. The engine is able to recognize the Models present in the application, indeed Models are the only types of variable allowed.

### Alternatives TODO

### The field `rule` TODO

### Doctor TODO

### Logger TODO

## Grammar definition TODO
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
 
<img src="http://25.media.tumblr.com/275b8a41709b427e8a81fb046f06364a/tumblr_mqxx57LeMC1sbhz3go1_400.gif" />