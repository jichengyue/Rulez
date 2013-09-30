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

### Boolean Expression Syntax (for Rules and Alternatives)
In the expression of a certain Rule (rule field) or Alternative (condition and alternative fields) is possible to reference Parameters, Functions and Variables.

To reference a Parameter, it must match exactly one of parameter names' comma separated specified in the field Parameters of the Rule. For Example:
```
Parameters:
    par1, par2, par3

Expression:
    par2 >= (3 - par3) && par1 != "foobar"
```

To reference a Function simply write the identifier of the Function available list. For Example:
```
Available functions:
    thetruth 
    alie 
    date_today 
    datetime_now

Expression:
    thetruth == true
```

To reference a Variable simply write the identifier of the Variable followed by a field from Variable available list dot separated. For Example:
```
Available variables:
    your_variable (YourModel) - description of this variable
      .yourmodelfield1
      .yourmodelfield2
      ...
      .yourmodelfieldN

Expression:
    your_variable.yourmodelfield2 != 5
```

For more information on how to write correctly Rules and Alternatives take a look at their sections and also at Grammar definition section.

### Doctor
The Doctor is an amazing tool that is able to understand if information of all Rulez Engine is still coherent after every single modification to Rules, Contexts or Variables. To verify if all is setted correctly go to Rulex Dashboard and press Run Doctor button in Doctor panel. In case of errors, specific instructions will be given in order to easily fix all problems.

### Logger
Rulez comes with a built-in logger to keep track of actions.
You can view it in your log directory (filename is rulez.log) or you can view the last records in the rulez pages.
Log entries are tagged with standard rails log levels (debug, info, error, fatal, warning) with timestamp.


## Grammar definition
The Grammar skips all spaces, tabs and black characters of any kind, so it is possible write rules with indentation and spaces between elements. Each rule returns a boolean value that is its evaluation.

* `root` of the parsed tree is a list of `boolean_operation`.
* boolean operations are made of `boolean_operator` and `boolean_operand` elements.
* boolean operators are AND (`&&`), OR (`||`), NOT (`!`).
* boolean operands are `boolean_value` or `compare_operation` elements.
* boolean values are `true` or `false`.
* compare operations are made of `compare_operator`,`compare_operand` and `boolean_value` elements.
* compare operators are Greater (`>`), Less (`<`), Greater Equal (`>=`), Less Equal (`<=`), Not Equal (`!=`), Equal (`==`)
* compare operands are a list of `mathematical_operation`.
* mathematical operations are made of `mathematical_operator` and `mathematical_operand` elements.
* matematical operators are Sum (`+`), Difference (`-`), Multiplication (`*`), Division (`/`), Minus (`-`)
* matematical operands are `datetime_value`, `date_value`, `string_value`, `float_value`, `integer_value`, `variable_value` and `arithmetic_datetime_value` elements.
* datetime values are in the form DD//MM//YYYY#hh:mm:ss (DD: days, MM: months, YYYY: years, hh: hours, mm: minutes, ss: seconds).
* date values are in the form DD//MM//YYYY (DD: days, MM: months, YYYY: years).
* string values are wrapped between `"` and `"`.
* float values are normal float numbers
* integer values are normal integer numbers
* arithmetic datetime values are an integer follower by `.` and one word that specify which kind of datetime element is (ex: 2.year, 5.minutes, ecc...).
* variable values are `context_variable` or `function` elements.
* functions are identifier
* context_variables are identifier.identifier

The Grammar handles correctly operator precedence (even with brackets) and semantic value of all elements of operations. For more detailed information watch at the definition below:

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

math_operand =  datetime_value            |
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
