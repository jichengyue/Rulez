require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../lib/rulez/parser/rulez_syntax_analyzer.rb')

describe SyntaxAnalyzer do
  
  before(:all) { @syntax_analyzer = SyntaxAnalyzer.new }

  context "Primitives Values" do

    describe "valid parsing" do
      it "skip all whitespace character" do
        rule = "\t true        \t      == \n true"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Boolean Values" do
        rule = "true"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "false"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Integer Values" do
        rule = "2476 == 2476"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Float Values" do
        rule = "423.3408 == 423.3408"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses String Values" do
        rule = "\"MyString\" == \"MyString\""
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Date Values" do
        rule = "16//02//1988 == 16//02//1988"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses DateTime Values" do
        rule = "16//02//1988#23:59:59 == 16//02//1988#23:59:59"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Arithmetic DataTime Values" do
        rule = "1.second == 1.second"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.minute == 1.minute"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.hour == 1.hour"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.day == 1.day"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.month == 1.month"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.year == 1.year"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.seconds == 5.seconds"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.minutes == 5.minutes"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.hours == 5.hours"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.days == 5.days"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.months == 5.months"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.years == 5.years"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.second == 5.seconds"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.minute == 5.minutes"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.hour == 5.hours"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.day == 5.days"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.month == 5.months"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "5.year == 5.years"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Functions" do
        rule = "myfunction == true"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Parameters" do
        rule = "myparameter == 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Variables" do
        rule = "myvariable.id == \"MyString\""
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end
    end

    describe "invalid parsing" do
      it "does not parse expressions that return Boolean Values" do
        rule = "()"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "7"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "432.34242"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "\"MyString\""
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "16//02//1988"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "16//02//1988#23:59:59"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "myfunction"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "myparameter"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "myparameter.myvariable"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
      end
    end
  end

  context "Logical Operators" do

    describe "valid parsing" do
      it "parses all Logical Operators" do
        rule = "true || false"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "true && false"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "!true"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses multiple Logical Operations cascade" do
        rule = "true && !false || true && false || !false"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Logical Operations with brackets" do
        rule = "(!(true) && (false || true))"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error    
      end
    end

    describe "invalid parsing" do
      it "does not parse incomplete Logical Operations" do
        rule = "true || "
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
        
        rule = "true &&"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "! "
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
      end

      it "does not parse Logical Operations on other data except to Boolean Values" do
        rule = "true || ()"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || 3"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || 3.3"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || \"MyString\""
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || 16//02//1988"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || 16//02//1988#23:59:59"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || myfunction"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || myparameter"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "true || myvariable.id"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
      end
    end
  end

  context "Compare Operators" do

    describe "valid parsing" do
      it "parses all Compare Operators" do
        rule = "5 <= 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
        
        rule = "5 < 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
        
        rule = "5 >= 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
        
        rule = "5 >= 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
        
        rule = "5 != 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
        
        rule = "5 == 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "myfunction == myfunction"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "myparameter == myparameter"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "myvariable.id == myvariable.id"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "true == myfunction"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "\"MyString\" == myvariable.id"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end
    end

    describe "invalid parsing" do
      it "does not parse Compare Operations cascade" do
        rule = "5 == 10 < 34 > 2"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
      end

      it "does not parse incomplete Compare Operations" do
        rule = "5 <= "
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "5 < "
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "5 >= "
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = " > 5"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = " != 5"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = " == 5"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
      end
    end
  end

  context "Mathematical Operations" do

    describe "valid parsing" do
      it "parses all Mathematical Operators" do
        rule = "7 + 5 == 13"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "7 - 5 == 2"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "7 * 5 == 35"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "7 / 7 == 1"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "7 + (-5) == -35"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "7 + -5 == -35"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "--------5 == 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.second + 1.second == 2.seconds"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.second - 2.second == -1.seconds"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.second + 1.minute == 61.seconds"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.minute + 1.hour == 61.minutes"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.hour + 1.day == 25.hours"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "1.day + 1.month == 31.days"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988 + 1.day == 17//02//1988"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988 + 1.month == 16//03//1988"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988 + 1.year == 16//02//1989"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "28//02//1988 + 1.day == 29//02//1988"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "29//02//1988 + 1.day == 01//03//1988"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "31//12//1988 + 1.day == 01//01//1989"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988#13:20:59 + 1.second == 16//02//1988#13:21:00"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988#13:59:59 + 1.minute == 16//02//1988#14:00:59"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988#23:59:59 + 1.hour == 17//02//1988#00:59:59"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

        rule = "16//02//1988#12:10:20 + 1.second + 1.minute + 1.hour + 1.day + 1.month + 1.year == 17//03//1989#13:11:21"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses multiple Mathematical Operations cascading in both Operands" do
        rule = "7 + 5 - 4 * 3 * 45 / 2 - 4 >= 2 + 34 / 4 * 5"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end

      it "parses Mathematical Operations with brackets" do 
        rule = "(2 + (7 * 5) + 23 - 14) / 2 + (9 * 4 - 6) >= (0)"
        lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
      end
    end

    describe "invalid parsing" do
      it "does not parse Mathematical Operations alone" do
        rule = "2 + 7"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "2 - 7"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "2 * 7"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "2 / 7"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error

        rule = "-7"
        lambda{@syntax_analyzer.parse(rule)}.should raise_error
      end
    end
  end

  context "Miscellaneous" do
    it "does not handle type checking on Primitives" do
      rule = "3 + \"MyString\" == true"
      lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

      rule = "16//02//1988#23:59:59 * myfunction == 3.221"
      lambda{@syntax_analyzer.parse(rule)}.should_not raise_error

      rule = "16//02//1988 - myvariable.id == myparameter"
      lambda{@syntax_analyzer.parse(rule)}.should_not raise_error
    end

    #this is the only type checking till now. It is in the grammar not in the semantic.
    it "does not parse Compare Operations <, <=, >, >= with Boolean Operand" do
      rule = "true <= false"
      lambda{@syntax_analyzer.parse(rule)}.should raise_error

      rule = "true < false"
      lambda{@syntax_analyzer.parse(rule)}.should raise_error

      rule = "true >= false"
      lambda{@syntax_analyzer.parse(rule)}.should raise_error

      rule = "true > false"
      lambda{@syntax_analyzer.parse(rule)}.should raise_error
    end
  end
end