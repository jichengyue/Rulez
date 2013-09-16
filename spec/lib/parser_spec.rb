require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../lib/rulez/parser/rulez_parser.rb')

describe RulezParser do
  
  before(:all) do
    @parser = RulezParser.new
    @myvariable = Restaurant.new({name: "MyRestaurantName", city: "GothamCity"})
    @myvariable.save!
    @context_variables = {}
    @context_variables["myvariable"] = @myvariable
    Rulez::Parser.set_context_variables(@context_variables)
    @params = {}
    @params[:myparameter] = 5
    Rulez::Parser.set_parameters(@params)
  end

  it "create a valid RulezParser" do
    @parser.should_not be_nil
  end 

  context "the Syntax" do

    context "Primitives Values" do

      describe "valid parsing" do
        it "skip all whitespace character" do
          rule = "\t true        \t      == \n true"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Boolean Values" do
          rule = "true"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "false"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Integer Values" do
          rule = "2476 == 2476"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Float Values" do
          rule = "423.3408 == 423.3408"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses String Values" do
          rule = "\"MyString\" == \"MyString\""
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Date Values" do
          rule = "16//02//1988 == 16//02//1988"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses DateTime Values" do
          rule = "16//02//1988#23:59:59 == 16//02//1988#23:59:59"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Arithmetic DataTime Values" do
          rule = "1.second == 1.second"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "1.minute == 1.minute"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "1.hour == 1.hour"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "1.day == 1.day"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "1.month == 1.month"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "1.year == 1.year"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.seconds == 5.seconds"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.minutes == 5.minutes"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.hours == 5.hours"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.days == 5.days"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.months == 5.months"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.years == 5.years"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.second == 5.seconds"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.minute == 5.minutes"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.hour == 5.hours"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.day == 5.days"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.month == 5.months"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "5.year == 5.years"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Functions" do
          rule = "thetruth == true"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Parameters" do
          rule = "myparameter == 5"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Variables" do
          rule = "myvariable.id == 1"
          lambda{@parser.parse(rule)}.should_not raise_error
        end
      end

      describe "invalid parsing" do
        it "does not parse expressions that return Boolean Values" do
          rule = "()"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "7"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "432.34242"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "\"MyString\""
          lambda{@parser.parse(rule)}.should raise_error

          rule = "16//02//1988"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "16//02//1988#23:59:59"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "thetruth"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "myparameter"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "myparameter.id"
          lambda{@parser.parse(rule)}.should raise_error
        end
      end
    end

    context "Logical Operators" do

      describe "valid parsing" do
        it "parses all Logical Operators" do
          rule = "true || false"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "true && false"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "!true"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses multiple Logical Operations cascade" do
          rule = "true && !false || true && false || !false"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Logical Operations with brackets" do
          rule = "(!(true) && (false || true))"
          lambda{@parser.parse(rule)}.should_not raise_error    
        end
      end

      describe "invalid parsing" do
        it "does not parse incomplete Logical Operations" do
          rule = "true || "
          lambda{@parser.parse(rule)}.should raise_error
          
          rule = "true &&"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "! "
          lambda{@parser.parse(rule)}.should raise_error
        end

        it "does not parse Logical Operations on other data except to Boolean Values" do
          rule = "true || ()"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || 3"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || 3.3"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || \"MyString\""
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || 16//02//1988"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || 16//02//1988#23:59:59"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || thetruth"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || myparameter"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "true || myvariable.id"
          lambda{@parser.parse(rule)}.should raise_error
        end
      end
    end

    context "Compare Operators" do

      describe "valid parsing" do
        it "parses all Compare Operators" do
          rule = "5 <= 5"
          lambda{@parser.parse(rule)}.should_not raise_error
          
          rule = "5 < 5"
          lambda{@parser.parse(rule)}.should_not raise_error
          
          rule = "5 >= 5"
          lambda{@parser.parse(rule)}.should_not raise_error
          
          rule = "5 >= 5"
          lambda{@parser.parse(rule)}.should_not raise_error
          
          rule = "5 != 5"
          lambda{@parser.parse(rule)}.should_not raise_error
          
          rule = "5 == 5"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "thetruth == thetruth"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "myparameter == myparameter"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "myvariable.id == myvariable.id"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "true == thetruth"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "\"MyString\" == myvariable.id"
          lambda{@parser.parse(rule)}.should_not raise_error
        end
      end

      describe "invalid parsing" do
        it "does not parse Compare Operations cascade" do
          rule = "5 == 10 < 34 > 2"
          lambda{@parser.parse(rule)}.should raise_error
        end

        it "does not parse incomplete Compare Operations" do
          rule = "5 <= "
          lambda{@parser.parse(rule)}.should raise_error

          rule = "5 < "
          lambda{@parser.parse(rule)}.should raise_error

          rule = "5 >= "
          lambda{@parser.parse(rule)}.should raise_error

          rule = " > 5"
          lambda{@parser.parse(rule)}.should raise_error

          rule = " != 5"
          lambda{@parser.parse(rule)}.should raise_error

          rule = " == 5"
          lambda{@parser.parse(rule)}.should raise_error
        end
      end
    end

    context "Mathematical Operations" do

      describe "valid parsing" do
        it "parses all Mathematical Operators" do
          rule = "7 + 5 == 13"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "7 - 5 == 2"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "7 * 5 == 35"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "7 / 7 == 1"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "7 + (-5) == -35"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "7 + -5 == -35"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "--------5 == 5"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses multiple Mathematical Operations cascading in both Operands" do
          rule = "7 + 5 - 4 * 3 * 45 / 2 - 4 >= 2 + 34 / 4 * 5"
          lambda{@parser.parse(rule)}.should_not raise_error
        end

        it "parses Mathematical Operations with brackets" do 
          rule = "(2 + (7 * 5) + 23 - 14) / 2 + (9 * 4 - 6) >= (0)"
          lambda{@parser.parse(rule)}.should_not raise_error
        end
      end

      describe "invalid parsing" do
        it "does not parse Mathematical Operations alone" do
          rule = "2 + 7"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "2 - 7"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "2 * 7"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "2 / 7"
          lambda{@parser.parse(rule)}.should raise_error

          rule = "-7"
          lambda{@parser.parse(rule)}.should raise_error
        end
      end
    end

    context "Miscellaneous Syntax" do

      #this is the only type checking till now. It is in the grammar not in the semantic.
      it "does not parse Compare Operations <, <=, >, >= with Boolean Operand" do
        rule = "true <= false"
        lambda{@parser.parse(rule)}.should raise_error

        rule = "true < false"
        lambda{@parser.parse(rule)}.should raise_error

        rule = "true >= false"
        lambda{@parser.parse(rule)}.should raise_error

        rule = "true > false"
        lambda{@parser.parse(rule)}.should raise_error
      end
    end
  end

  context "the Semantic" do
    describe "Primitives" do
      it "evaluates Variables" do
        rule = "myvariable.name == \"MyRestaurantName\""
        @parser.parse(rule).should be_true

        rule = "myvariable.name != \"MyRestaurantName\""
        @parser.parse(rule).should be_false
      end

      it "evaluates Parameters" do
        rule = "myparameter == 5"
        @parser.parse(rule).should be_true

        rule = "myparameter != 5"
        @parser.parse(rule).should be_false
      end

      it "evaluates Functions" do
        rule = "thetruth == true"
        @parser.parse(rule).should be_true
        
        rule = "thetruth != true"
        @parser.parse(rule).should be_false

        rule = "alie == false"
        @parser.parse(rule).should be_true

        rule = "alie != false"
        @parser.parse(rule).should be_false 
      end

      it "evaluates Boolean Values" do
        rule = "true"
        @parser.parse(rule).should be_true

        rule = "false"
        @parser.parse(rule).should be_false

        rule = "true == true"
        @parser.parse(rule).should be_true

        rule = "true == false"
        @parser.parse(rule).should be_false

        rule = "false == true"
        @parser.parse(rule).should be_false

        rule = "false == false"
        @parser.parse(rule).should be_true
      end

      it "evaluates Integers" do
        rule = "10 == 10"
        @parser.parse(rule).should be_true
      end

      it "evaluates Floats" do
        rule = "10.98 == 10.98"
        @parser.parse(rule).should be_true
      end

      it "evaluates Strings" do
        rule = "\"MyString\" == \"MyString\""
        @parser.parse(rule).should be_true
      end

      it "evaluates Dates" do
        rule = "16//02//1988 == 16//02//1988"
        @parser.parse(rule).should be_true
      end

      it "evaluates DateTimess" do
        rule = "16//02//1988#23:59:59 == 16//02//1988#23:59:59"
        @parser.parse(rule).should be_true
      end
    end

    describe "Mathematical Operations" do
      it "evaluates all basic Mathematical Operations correctly" do
        rule = "10 + 10 == 20"
        @parser.parse(rule).should be_true

        rule = "10 - 10 == 0"
        @parser.parse(rule).should be_true

        rule = "10 * 10 == 100"
        @parser.parse(rule).should be_true

        rule = "10 / 10 == 1"
        @parser.parse(rule).should be_true

        rule = "-4 - 1 == -5"
        @parser.parse(rule).should be_true      

        rule = "\"MyString\" + \"MyString\" == \"MyStringMyString\""
        @parser.parse(rule).should be_true

        rule = "1.second + 1.second == 2.seconds"
        @parser.parse(rule).should be_true

        rule = "1.second - 2.second == -1.seconds"
        @parser.parse(rule).should be_true

        rule = "1.second + 1.minute == 61.seconds"
        @parser.parse(rule).should be_true

        rule = "1.minute + 1.hour == 61.minutes"
        @parser.parse(rule).should be_true

        rule = "1.hour + 1.day == 25.hours"
        @parser.parse(rule).should be_true

        rule = "1.day + 1.month == 31.days"
        @parser.parse(rule).should be_true

        rule = "16//02//1988 + 1.day == 17//02//1988"
        @parser.parse(rule).should be_true

        rule = "16//02//1988 + 1.month == 16//03//1988"
        @parser.parse(rule).should be_true

        rule = "16//02//1988 + 1.year == 16//02//1989"
        @parser.parse(rule).should be_true

        # leap year contains 29 February
        rule = "28//02//1988 + 1.day == 29//02//1988"
        @parser.parse(rule).should be_true

        # forward by one month if I add a day at the end of the month
        rule = "29//02//1988 + 1.day == 01//03//1988"
        @parser.parse(rule).should be_true

        # forward by one year if I add one day to New Year's Eve
        rule = "31//12//1988 + 1.day == 01//01//1989"
        @parser.parse(rule).should be_true

        # advances one minute if I add another second to 59 seconds
        rule = "16//02//1988#13:20:59 + 1.second == 16//02//1988#13:21:00"
        @parser.parse(rule).should be_true

        # advances on hour if I add anoter minute to 59 minutes
        rule = "16//02//1988#13:59:59 + 1.minute == 16//02//1988#14:00:59"
        @parser.parse(rule).should be_true

        # advances on day if I add anoter hour to 23 hours
        rule = "16//02//1988#23:59:59 + 1.hour == 17//02//1988#00:59:59"
        @parser.parse(rule).should be_true

        # supports multiple date and datetime operations in the same expression
        rule = "16//02//1988#12:10:20 + 1.second + 1.minute + 1.hour + 1.day + 1.month + 1.year == 17//03//1989#13:11:21"
        @parser.parse(rule).should be_true
      end

      it "respects precedence on mathematical operators" do
        rule = "5 + 6 * 3 == 23"
        @parser.parse(rule).should be_true

        rule = "5 + 6 * 3 == 33"
        @parser.parse(rule).should be_false

        rule = "5 + 6 * 2 / 12 + 2 - 18 / 6 == 5"
        @parser.parse(rule).should be_true
      end

      it "behaviours in the same way in rulez and in ruby" do
        rule = "10 + 10 == 20"
        eval(rule).should be_true

        rule = "10 - 10 == 0"
        eval(rule).should be_true

        rule = "10 * 10 == 100"
        eval(rule).should be_true

        rule = "10 / 10 == 1"
        eval(rule).should be_true

        rule = "-4 - 1 == -5"
        eval(rule).should be_true

        rule = "\"MyString\" + \"MyString\" == \"MyStringMyString\""
        eval(rule).should be_true
      
        rule = "5 + 6 * 3 == 23"
        eval(rule).should be_true

        rule = "5 + 6 * 3 == 33"
        eval(rule).should be_false

        rule = "5 + 6 * 2 / 12 + 2 - 18 / 6 == 5"
        eval(rule).should be_true
      end
    end

    describe "Compare Operations" do
      it "evaluates all basic Compare Operations" do
        rule = "1 == 1"
        @parser.parse(rule).should be_true

        rule = "1 != 0"
        @parser.parse(rule).should be_true

        rule = "1 <= 1"
        @parser.parse(rule).should be_true

        rule = "1 < 2"
        @parser.parse(rule).should be_true

        rule = "1 >= 1"
        @parser.parse(rule).should be_true

        rule = "2 > 1"
        @parser.parse(rule).should be_true

        rule = "\"MyString\" == \"MyString\""
        @parser.parse(rule).should be_true

        rule = "\"MyString1\" != \"MyString2\""
        @parser.parse(rule).should be_true

        rule = "16//02//1988 == 16//02//1988"
        @parser.parse(rule).should be_true

        rule = "16//02//1988 != 16//02//2013"
        @parser.parse(rule).should be_true

        rule = "16//02//1988#23:59:59 == 16//02//1988#23:59:59"
        @parser.parse(rule).should be_true

        rule = "16//02//1988#23:59:59 != 17//02//1988#00:00:00"
        @parser.parse(rule).should be_true
      end

      it "behaviours in the same way in rulez and in ruby" do
        rule = "1 == 1"
        eval(rule).should be_true

        rule = "1 != 0"
        eval(rule).should be_true

        rule = "1 <= 1"
        eval(rule).should be_true

        rule = "1 < 2"
        eval(rule).should be_true

        rule = "1 >= 1"
        eval(rule).should be_true

        rule = "2 > 1"
        eval(rule).should be_true

        rule = "\"MyString\" == \"MyString\""
        eval(rule).should be_true

        rule = "\"MyString1\" != \"MyString2\""
        eval(rule).should be_true
      end
    end

    describe "Boolean Operations" do
      it "evaluates all basic Boolean Operations" do
        rule = "true && true"
        @parser.parse(rule).should be_true

        rule = "true && false"
        @parser.parse(rule).should be_false

        rule = "false && true"
        @parser.parse(rule).should be_false

        rule = "false && false"
        @parser.parse(rule).should be_false

        rule = "true || true"
        @parser.parse(rule).should be_true

        rule = "true || false"
        @parser.parse(rule).should be_true

        rule = "false || true"
        @parser.parse(rule).should be_true

        rule = "false || false"
        @parser.parse(rule).should be_false

        rule = "!true"
        @parser.parse(rule).should be_false

        rule = "!false"
        @parser.parse(rule).should be_true
      end

      it "respects precedence on logical operators" do
        # reference to the fixed issue #9
        rule = "true && true || false && true || false && false"
        @parser.parse(rule).should be_true

        rule = "true && true || false && true || false && false"
        @parser.parse(rule).should_not be_false
      end

      it "" do
        rule = "true && true"
        eval(rule).should be_true

        rule = "true && false"
        eval(rule).should be_false

        rule = "false && true"
        eval(rule).should be_false

        rule = "false && false"
        eval(rule).should be_false

        rule = "true || true"
        eval(rule).should be_true

        rule = "true || false"
        eval(rule).should be_true

        rule = "false || true"
        eval(rule).should be_true

        rule = "false || false"
        eval(rule).should be_false

        rule = "!true"
        eval(rule).should be_false

        rule = "!false"
        eval(rule).should be_true

        rule = "true && true || false && true || false && false"
        eval(rule).should be_true

        rule = "true && true || false && true || false && false"
        eval(rule).should_not be_false
      end
    end

    describe "Miscellaneous Semantic" do
      it "handles Variables in mixed Operations" do
        rule = "myvariable.city + \"Batman\" == \"GothamCityBatman\""
        @parser.parse(rule).should be_true

        rule = "\"Batman\" + myvariable.city == \"BatmanGothamCity\""
        @parser.parse(rule).should be_true

        rule = "\"GothamCityBatman\" == myvariable.city + \"Batman\""
        @parser.parse(rule).should be_true

        rule = "\"BatmanGothamCity\" == \"Batman\" + myvariable.city"
        @parser.parse(rule).should be_true
      end

      it "handles Parameters in mixed Operations" do
        rule = "myparameter + 5 == 10"
        @parser.parse(rule).should be_true

        rule = "5 + myparameter == 10"
        @parser.parse(rule).should be_true

        rule = "10 == myparameter + 5"
        @parser.parse(rule).should be_true

        rule = "10 == 5 + myparameter"
        @parser.parse(rule).should be_true
      end

      it "handles Functions in mixed Operations" do
        rule = "thetruth == true || false"
        @parser.parse(rule).should be_true

        rule = "false || thetruth == true"
        @parser.parse(rule).should be_true
      end

      it "complex expressions" do
        # rule with mixed parameter, function and context variable
        rule = "myvariable.city == \"GothamCity\" && myparameter * 2 - 3 == 7 && !false == thetruth"
        @parser.parse(rule).should be_true

        # this test fail only at Christmas 2013
        rule = "date_today != 25//12//2013"
        @parser.parse(rule).should be_true

        # this rule returns true only till the end of 2013 
        # (after that date you can comment or eliminate this test)
        rule = "date_today >= 01//09//2013 && date_today <= 31//12//2013"
        @parser.parse(rule).should be_true

        # fill free to add others!
      end 
    end
  end
end