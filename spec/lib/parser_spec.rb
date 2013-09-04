require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../lib/rulez/parser/rulez_parser.rb')

describe RulezParser do
  
  before(:all) do
    @parser = RulezParser.new
    @myvariable = Restaurant.new({name: "MyRestaurantName", city: "GothamCity"})
    @myvariable.save
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

        it "parses Functions" do
          rule = "myfunction == true"
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

          rule = "myfunction"
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

          rule = "true || myfunction"
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

          rule = "myfunction == myfunction"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "myparameter == myparameter"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "myvariable.id == myvariable.id"
          lambda{@parser.parse(rule)}.should_not raise_error

          rule = "true == myfunction"
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

    context "Miscellaneous" do

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
    it "valuates Variables" do
      rule = "myvariable.id == 1"
      @parser.parse(rule).should be_true

      rule = "myvariable.id != 1"
      @parser.parse(rule).should be_false
    end

    it "valuates Parameters" do
      rule = "myparameter == 5"
      @parser.parse(rule).should be_true

      rule = "myparameter != 5"
      @parser.parse(rule).should be_false
    end
  end
end







