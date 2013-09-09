require "spec_helper.rb"

class FakeMethodsClass
end

module FakeModule
end

class FakeModel1 < ActiveRecord::Base
end

class FakeModel2 < ActiveRecord::Base
end

class FakeTarget
  @@num = 5
  @@str = "MyString"
  @@bool = true
  
  def self.num
    @@num
  end

  def self.str
    @@str
  end

  def self.bool
    @@bool
  end
end

module Rulez
  describe Rulez do
    context "module" do
      describe "configuring methods_class" do
        before(:each) do 
          Rulez::class_variable_set(:@@methods_class, nil)
        end

        after(:all) do
          Rulez::set_methods_class(RulezMethods::Methods)
        end
        
        it "sets the methods class" do
          Rulez::set_methods_class(FakeMethodsClass).should == FakeMethodsClass
        end

        it "should raise exeption if param is not a class" do
          methods_class = "notAClass"
          lambda {Rulez::set_methods_class(FakeMethodsClass).should raise_error(RuntimeError, "Parameter should be a class")}
          lambda {Rulez::set_methods_class(FakeModule).should raise_error(RuntimeError, "Parameter should be a class")}
        end

        it "should raise exception if methods_class was not set" do
          lambda {Rulez::get_methods_class.should raise_error(RuntimeError, "Init error, methods class is not present.")}
        end

        it "gets the methods_class" do
          Rulez::set_methods_class(FakeMethodsClass)
          Rulez::get_methods_class.should == FakeMethodsClass
        end
      end

      describe "configuring Models" do
        before(:all) do
          @models = Rulez::get_models
        end

        before(:each) do
          Rulez::class_variable_set(:@@models, nil)
        end

        after(:all) do
          Rulez::set_models(@models)
        end

        it "sets the models" do
          Rulez::set_models([FakeModel1, FakeModel2]).should match_array([FakeModel1, FakeModel2])
        end

        it "should raise exception if param is not an array" do
          lambda {Rulez::set_models(FakeModel1).should raise_error(RuntimeError, "Parameter should be an array")}
        end

        it "should raise exception if array does not contains only models" do
          lambda {Rulez::set_models.should raise_error(RuntimeError, "Found a member of the array that is not a model")}
        end

        it "should raise exception if models were not set" do
          lambda {Rulez::get_models.should raise_error(RuntimeError, "Init error, models not initialized")}
        end

        it "should get models" do
          Rulez::set_models([FakeModel1, FakeModel2])
          Rulez::get_models.should match_array([FakeModel1, FakeModel2])
        end
      end
    end

    context "Engine" do
      describe "logger" do
        describe "immediately flushes file and" do
          it "logs info level messages" do
            Engine.info_log("Testing info level log")
            Engine.flush_log
            last_line = `tail -n 1 log/rulez.log`
            last_line.include?("[INFO]").should be_true
            last_line.include?("Testing info level log").should be_true
          end

          it "logs debug level messages" do 
            Engine.debug_log("Testing debug level log")
            Engine.flush_log
            last_line = `tail -n 1 log/rulez.log`
            last_line.include?("[DEBUG]").should be_true
            last_line.include?("Testing debug level log").should be_true
          end

          it "logs warning level messages" do 
            Engine.warning_log("Testing warning level log")
            Engine.flush_log
            last_line = `tail -n 1 log/rulez.log`
            last_line.include?("[WARNING]").should be_true
            last_line.include?("Testing warning level log").should be_true
          end

          it "logs error level messages" do
            Engine.error_log("Testing error level log")
            Engine.flush_log
            last_line = `tail -n 1 log/rulez.log`
            last_line.include?("[ERROR]").should be_true
            last_line.include?("Testing error level log").should be_true
          end

          it "logs fatal level messages" do
            Engine.fatal_log("Testing fatal level log")
            Engine.flush_log
            last_line = `tail -n 1 log/rulez.log`
            last_line.include?("[FATAL]").should be_true
            last_line.include?("Testing fatal level log").should be_true
          end
        end
      end

      describe "rulez?" do
        before(:each) do
          v1 = Variable.new(name: "var1", description: "v1desc", model: "Restaurant")
          v2 = Variable.new(name: "var2", description: "v2desc", model: "User")
          context = Context.new(name: "c1", description: "c1desc")
          context.variables = [v1,v2]
          rule = Rule.new(name: "r1", description: "r1desc", rule: "true", parameters: "p1, p2")
          rule.context = context
          rule.save!
        end

        describe "with target not set" do
          it "raises error if rulez called before setting target" do
            lambda {rulez?('r1').should raise_error(RuntimeError, "Target object not found. Did you forget to set the target?")}
          end
        end

        describe "with target set" do

          describe "without context variables set" do
            it "should raise error" do
              lambda {rulez?('r1').should raise_error(RuntimeError, "Mandatory parameters not set: var1, var2")}
            end
          end

          describe "with context variables set" do
            before(:each) do
              Rulez.set_rulez_target(self)

              @var1 = Restaurant.new(name: "RestaurantName", city: "Torino")
              @var1.save!
              @var2 = User.new(name: "UserName", age: 12)
              @var2.save!
            end

            it "should raise error if called with wrong rule name" do
              lambda {rulez?('nonexistent_rule').should raise_error(RuntimeError, "Can't find rule nonexistent_rule to evaluate!")}
            end

            it "should raise error if params are not an hash" do
              pending
            end

            it "should raise error if params are not the same requested by the rule" do
              pending
            end

            context "Alternative check" do
              before(:each) do
                @rule = Rule.find_by_name("r1")
                @a1 = Alternative.new(description: "a1desc", condition: "true", alternative: "true")
                @a2 = Alternative.new(description: "a2desc", condition: "true", alternative: "true")
                @a1.priority = 1
                @a2.priority = 2
                @a1.rule = @rule
                @a2.rule = @rule
                @rule.alternatives += [@a1, @a2]
                @rule.save!
              end

              it "evaluate alternatives" do
                pending
              end

              it "evaluate alternatives in correct priority order" do
                pending
              end

              it "evaluate rule when all alternatives have false condition" do
                pending
              end
            end
          end
        end
      end
    end

    describe "Parameter" do

      before(:each) do
        @v1 = Variable.new 
        @v1.name = "v1"
        @v1.description = "Myv1Description"
        @v1.model = "Restaurant"
        @v1.save!

        @c1 = Context.new
        @c1.name = "c1"
        @c1.description = "MyContextDescription"
        @c1.variables = [@v1]
        @c1.save!

        @rule = Rule.new
        @rule.name = "r1"
        @rule.description = "MyRuleDescription"
        @rule.parameters = ""
        @rule.rule = "true"
        @rule.context = @c1
        @rule.save!

        Rulez::set_rulez_target FakeTarget
      end

      after(:each) do
        @v1.destroy
        @c1.destroy
        @rule.destroy
      end

      it "raises error if try to evaluate a non-existent rule" do
        lambda{Rulez::rulez? "InexistentRule"}.should raise_error
      end

      it "makes correct evaluation of the rule when it is not present" do
        (Rulez::rulez? @rule.name).should_not be_false
        (Rulez::rulez? @rule.name).should be_true
      end

      it "is always an hash" do
        @rule.parameters = "p1, p2"
        @rule.rule = "p1 == 3 && p2 == 4"
        @rule.save!
        p1 = 3
        p2 = 4
        pars = [p1,p2]
        lambda{Rulez::rulez? @rule.name, pars}.should raise_error
        pars = {p1: 3, p2: 4}
        lambda{Rulez::rulez? @rule.name, pars}.should_not raise_error
      end

      it "matches exactly the one in the rule" do
        @rule.parameters = "p1, p2, p3"
        @rule.rule = "p1 == 3 && p2 == 4 && p3 == \"MyString\""
        @rule.save!
        pars = {p1: 3, p2: 4, p3: "MyString"}
        lambda{Rulez::rulez? @rule.name, pars}.should_not raise_error
      end

      it "raises error when Parameters defined in the rule are not all used" do
        @rule.parameters = "p1, p2, p3"
        @rule.rule = "p1 == 3 && p2 == 4 && p3 == \"MyString\""
        @rule.save!
        pars = {}
        lambda{Rulez::rulez? @rule.name, pars}.should raise_error
        pars = {p1: 3, p3: "MyString"}
        lambda{Rulez::rulez? @rule.name, pars}.should raise_error
      end

      it "raises error when some Parameters defined in the rule are missing in the call of rulez? method" do
        @rule.parameters = "p1, p2, p3"
        @rule.rule = "p1 == 3 && p2 == 4 && p3 == \"MyString\""
        @rule.save!
        pars = {p5: 3, p2: 4, p3: "MyString"}
        lambda{Rulez::rulez? @rule.name, pars}.should raise_error
      end

      it "skips extra Parameters in the rulez? method call if they are not defined in the rule, but log error will be reported" do
        @rule.parameters = "p1, p2, p3"
        @rule.rule = "p1 == 3 && p2 == 4 && p3 == \"MyString\""
        @rule.save!
        pars = {p1: 3, p2: 4, p3: "MyString",p4: 32, p5: "MyOtherString"}
        lambda{Rulez::rulez? @rule.name, pars}.should_not raise_error
      end

      it "evaluates correctly Rules with Parameters" do
        @rule.parameters = "p1, p2, p3"
        @rule.rule = "p1 == "+FakeTarget.num.to_s+" && p2 == \""+FakeTarget.str.to_s+"\" && p3 == "+FakeTarget.bool.to_s
        @rule.save!
        pars = {p1: FakeTarget.num, p2: FakeTarget.str, p3: FakeTarget.bool}
        lambda{Rulez::rulez? @rule.name, pars}.should_not raise_error
        (Rulez::rulez? @rule.name, pars).should be_true
      end
    end
  end
end








