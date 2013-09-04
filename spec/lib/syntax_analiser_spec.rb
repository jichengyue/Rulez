require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../lib/rulez/parser/rulez_syntax_analyzer.rb')

describe SyntaxAnalyzer do
  
  before(:all) { @syntax_analizer = SyntaxAnalyzer.new }

  context "Primitives Values" do

    describe "valid parsing" do
      it "skip all whitespace character" do
        rule = "\t true        \t      == \n true"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Boolean Values" do
        rule = "true"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "false"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Integer Values" do
        rule = "2476 == 2476"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Float Values" do
        rule = "423.3408 == 423.3408"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses String Values" do
        rule = "\"MyString\" == \"MyString\""
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Date Values" do
        rule = "16//02//1988 == 16//02//1988"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses DateTime Values" do
        rule = "16//02//1988#23:59:59 == 16//02//1988#23:59:59"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Functions" do
        rule = "myfunction == true"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Parameters" do
        rule = "myparameter == 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Variables"do
        rule = "myvariable.myfield == \"MyString\""
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end
    end

    describe "invalid parsing" do
      it "does not parse expressions that return Boolean Values" do
        rule = "()"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "7"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "432.34242"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "\"MyString\""
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "16//02//1988"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "16//02//1988#23:59:59"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "myfunction"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "myparameter"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "myparameter.myvariable"
        lambda{@syntax_analizer.parse(rule)}.should raise_error
      end
    end
  end

  context "Logical Operators" do

    describe "valid parsing" do
      it "parses all Logical Operators" do
        rule = "true || false"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "true && false"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "!true"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses multiple Logical Operations cascade" do
        rule = "true && !false || true && false || !false"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Logical Operations with brackets" do
        rule = "(!(true) && (false || true))"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error    
      end
    end

    describe "invalid parsing" do
      it "does not parse incomplete Logical Operations" do
        rule = "true || "
        lambda{@syntax_analizer.parse(rule)}.should raise_error
        
        rule = "true &&"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "! "
        lambda{@syntax_analizer.parse(rule)}.should raise_error
      end

      it "does not parse Logical Operations on other data except to Boolean Values" do
        rule = "true || ()"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || 3"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || 3.3"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || \"MyString\""
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || 16//02//1988"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || 16//02//1988#23:59:59"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || myfunction"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || myparameter"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true || myvariable.myfield"
        lambda{@syntax_analizer.parse(rule)}.should raise_error
      end
    end
  end

  context "Compare Operators" do

    describe "valid parsing" do
      it "parses all Compare Operators" do
        rule = "5 <= 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
        
        rule = "5 < 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
        
        rule = "5 >= 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
        
        rule = "5 >= 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
        
        rule = "5 != 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
        
        rule = "5 == 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "myfunction == myfunction"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "myparameter == myparameter"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "myvariable.myfield == myvariable.myfield"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "true == myfunction"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "\"MyString\" == myvariable.myfield"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end
    end

    describe "invalid parsing" do
      it "does not parse Compare Operations cascade" do
        rule = "5 == 10 < 34 > 2"
        lambda{@syntax_analizer.parse(rule)}.should raise_error
      end

      it "does not parse incomplete Compare Operations" do
        rule = "5 <= "
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "5 < "
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "5 >= "
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = " > 5"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = " != 5"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = " == 5"
        lambda{@syntax_analizer.parse(rule)}.should raise_error
      end

      #this is the only type checking till now. It is in the gramma not in the semantic.
      it "does non parse Compare Operations <, <=, >, >= with Boolean Operand" do
        rule = "true <= false"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true < false"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true >= false"
        lambda{@syntax_analizer.parse(rule)}.should raise_error

        rule = "true > false"
        lambda{@syntax_analizer.parse(rule)}.should raise_error
      end
    end
  end

  context "Mathematical Operations" do

    describe "valid parsing" do
      it "parses all Mathematical Operators" do
        rule = "7 + 5 == 13"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "7 - 5 == 2"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "7 * 5 == 35"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "7 / 7 == 1"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error

        rule = "7 + (-5) == -35"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses multiple Mathematical Operations cascading in both Operands" do
        rule = "7 + 5 - 4 * 3 * 45 / 2 - 4 >= 2 + 34 / 4 * 5"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end

      it "parses Mathematical Operations with brackets" do 
        rule = "(2 + (7 * 5) + 23 - 14) / 2 + (9 * 4 - 6) >= (0)"
        lambda{@syntax_analizer.parse(rule)}.should_not raise_error
      end
    end

    describe "invalid parsing" do

    end
  end
end







