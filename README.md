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
mount Rulez::Engine, at: "/rulez"
```

application_controller.rb:
```ruby
before_filter :set_rulez_target

private
  def set_rulez_target
    Rulez::set_rulez_target self
  end
```

### 2. Installation
Run from terminal:
```
bundle install
```

You can choose to use the full install option or to install each component apart.

* Full install - includes: migrations, log environment, rulez methods
  
  ```
  rake rulez:install:full
  rake db:migrate
  ```
  This installs the whole engine: migrations, log environment and rulez methods.
  It doesn't install the spec file (it can be installed after).

* Custom install
  * Migrations:
    
    ```
    rake rulez:install:migrations
    rake db:migrate
    ```
    This installs the migrations and creates the tables required to make the engine working.

  * Log environment:
   
    ```
    rake rulez:install:log_env
    ```
    This installs the log environment of the engine. All performed operations are logged in `log/rulez.log`
  
  * Rulez methods:
    
    ```
    rake rulez:install:methods
    ```
    This installs the file `lib/rulez_methods.rb`. See the **Rulez Methods** section.
  
  * Spec:
    
    ```
    rake rulez:install:tests
    ```
    This task installs a rspec test that automatically runs the **Doctor** when testing the application. (See Doctor section).
    
    **NB:** this task is NOT automatically installed by the full install.

### 3. Configure your first rule!

1. Launch the server, open the browser and go to `[your site]/rulez`
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
  if rulez? 'rulename', {param1: value1, param2: value2, param3: value3}
    ...
  end
  ```

## Web-based Features
The engine provides a visual web-based editor for the rules.

### Rules
They are the business rules.
When creating, it's prompted to enter:
  * An identifier **name** for the rule. It must be unique. It's important to choose carefully the name: once the rule is evaluated by code, renaming the rule may result in strings of code that reference to a non-existing rule.
  * An exhaustive **description** about the meaning of the rule and about when is to be applied
  * Some **parameters** (like the parameters of a function). If any, they must be declared writing down their names separated by comma.
  * The **context** in which the rule will be applied. (see the **Contexts** section)
  * The real **rule**. It's a boolean expression, whose result indicates whether or not the rule will enable the behaviour that you are trying to describe. (For further instructions, see the **Boolean expression syntax** section)

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
Once the rule is created, it's possible to insert some alternatives to it (see the section below)

### Alternatives
Sometimes it might be useful to add one or more *alternatives* to the rules.

An alternative is a kind of exception to the rule.

When creating an alternative, it's prompted to enter:
* A **description** for the alternative.
* The **condition** that triggers the alternative. It's a boolean expression, whose result indicates whether or not the alternative will be enabled. (For the syntax instructions see the **Boolean expression syntax** section)
* The real **alternative**. It's a boolean expression. If the alternative is enabled by the condition, this field replaces the main rule.

After the creation of the alternatives, they can be sorted dragging them in an ordered list. This assigns a priority level to each alternative.

## Code-side Features
### Applying a rule
* For evaluating a rule (without paramters), just call the function `rulez?` with a string containing the name of the rule.
  
  E.g.: An administrator defines a rule, named `create_new_users`, that describes the possibility to create new users.
  If you want to evaluate it in the code, you just have to write:
  ```ruby
  if rulez? 'create_new_users'
    # inner_code
  end
  ```
  This will executes `inner_code` only if the rule succeeds.

* For evaluating a rule with parameters, you can pass them to the rule in a hash:
  
  E.g.: An administrator defines a rule, named `use_advanced_tool_X`, that describes the possibility to use the advanced tool "X".
  Since the rule has a different behaviour if the user is a premium user, the rule is defined with a boolean parameter `premium`.
  For evaluating the rule, you have to pass to `rulez?` a value for that parameter, using a hash:
  ```ruby
  if rulez? 'use_advanced_tool_X', {premium: true}
    # inner_code
  end
  ```
  This will executes `inner_code` only if the rule succeeds.

### Boolean expression sintax TODO

### Doctor TODO

### Logger TODO

## Grammar definition
The grammar skips all spaces, tabs and black characters of any kind, so it is possible write rules with indentation and spaces between elements. Each rule returns a boolean value that is its evaluation.

The grammar is so defined:
```code
ROOT = bool_operation
bool_operation =  "(" bool_operation ")"                |
                    "!", bool_operation                 |
                    bool_operation "||" bool_operation  |
                    bool_operation "&&" bool_operation  |
                    bool_operand
  
bool_operand =  boolean_value  |
                  cmp_operation

cmp_operation = cmp_operand ">" cmp_operand         |
                  cmp_operand "<" cmp_operand       |
                  cmp_operand ">=" cmp_operand      |
                  cmp_operand "<=" cmp_operand      |
                  cmp_operand "!=" cmp_operand      |
                  cmp_operand "==" cmp_operand      |
                  cmp_operand "!=" boolean_value    |
                  cmp_operand "==" boolean_value    |
                  boolean_value "!=" cmp_operand    |
                  boolean_value "==" cmp_operand    |
                  boolean_value "!=" boolean_value  |
                  boolean_value "==" boolean_value   

cmp_operand = math_operation

math_operation =  "(" math_operation ")"              |
                    "-" math_operation                |
                    math_operation "/" math_operation |
                    math_operation "*" math_operation |
                    math_operation "-" math_operation |
                    math_operation "+" math_operation |
                    math_operand

math_operand =  datetime_value              |
                  date_value                |
                  string_value              |
                  float_value               |
                  integer_value             |
                  variable_value            |
                  arithmetic_datetime_value 

boolean_value = /true|false/

datetime_value = /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})(\#)([01][0-9]|2[0-3])(\:)([0-5][0-9])(\:)([0-5][0-9])/

date_value = /(([012][0-9]|3[01])(\/\/)(0[13578]|1[02])|([012][0-9]|30)(\/\/)(0[469]|11)|([012][0-9])(\/\/)(02))(\/\/)([0-9]{4})/

arithmetic_datetime_value = /([1-9][0-9]*|0)\.(second(s)?|minute(s)?|hour(s)?|day(s)?|month(s)?|year(s)?)/

string_value = /\"[a-zA-Z0-9 ]*\"/

function: /[a-zA-Z][a-zA-Z0-9_]*/

context_variable: /[a-zA-Z][a-zA-Z0-9_]*[.][a-zA-Z][a-zA-Z0-9_]*|[a-zA-Z][a-zA-Z0-9_]*/

variable_value =  context_variable  |
                    function
    
float_value = /([1-9][0-9]*|0)?\.[0-9]+/

integer_value = /[1-9][0-9]*|0/
```
