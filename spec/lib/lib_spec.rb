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
              lambda {rulez?("r1",["Mypar1",3])}.should raise_error
            end

            it "should raise error if params are not the same requested by the rule" do
              lambda {rulez?("r1",{}).should raise_error}
              lambda {rulez?("r1",{p1: 1}).should raise_error}
              lambda {rulez?("r1",{p1: 1, p2: 2, p3: 3}).should raise_error}
              lambda {rulez?("r1",{p1: 1, p2: 2}).should_not raise_error}
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
                lambda {rulez?("r1",{p1: 0, p2: 0}).should_not raise_error}
                lambda {rulez?("r1",{p1: 0, p2: 0}).should be_true}
              end

              it "evaluate alternatives in correct priority order" do
                @rule.alternatives.each do |a|
                  if(a.priority == 1)
                    a.condition = "true"
                    a.alternative = "true"
                  else
                    a.condition = "false"
                    a.alternative = "false"
                  end
                end
                @rule.save!
                lambda {rulez?("r1",{p1: 0, p2: 0}).should be_true}
                @rule.reload
                @rule.alternatives.each do |a|
                  if(a.priority == 2)
                    a.condition = "true"
                    a.alternative = "true"
                  else
                    a.condition = "false"
                    a.alternative = "false"
                  end
                end
                @rule.save!
                lambda {rulez?("r1",{p1: 0, p2: 0}).should be_true}
                @rule.reload
                @rule.alternatives.each do |a|
                  a.condition = "false"
                  a.alternative = "false"
                end
                @rule.save!
                lambda {rulez?("r1",{p1: 0, p2: 0}).should be_false}
              end

              it "evaluate rule when all alternatives have false condition" do
                @rule.rule = "true"
                @rule.alternatives.each do |a|
                  a.condition = "false"
                  a.alternative = "false"
                end
                @rule.save!
                lambda {rulez?("r1",{p1: 0, p2: 0}).should be_true}
              end
            end
          end
        end
      end

      context "Doctor" do
        describe "errors on Variables" do
          before(:all) do
            @models = Rulez::get_models
          end

          before(:each) do
            Rulez::class_variable_set(:@@models, nil)
            Rulez::set_models([FakeModel1, FakeModel2])
            Rulez::Variable.new(name: "MyVariable1Name", description: "MyVariable1Description", model: "FakeModel1").save!
            Rulez::Variable.new(name: "MyVariable2Name", description: "MyVariable2Description", model: "FakeModel2").save!
          end

          after(:each) do
            Rulez::Variable.find(:all).each do |v|
              v.destroy
            end
          end

          after(:all) do
            Rulez::set_models(@models)
          end

          it "raises error if a Variable refers to a non existent model" do
            Rulez::set_models([FakeModel1])
            errors = Rulez::doctor
            errors.should_not be_empty
            errors.length.should == 1

            Rulez::set_models([])
            errors = Rulez::doctor
            errors.should_not be_empty
            errors.length.should == 2
          end

          it "does not signal errors if all Variables are right" do
            errors = Rulez::doctor
            errors.should be_empty
          end
        end

        describe "errors on Rules" do
          before(:all) do
            @models = Rulez::get_models
          end          

          before(:each) do 
            Rulez::class_variable_set(:@@methods_class, nil)
            Rulez::set_methods_class(RulezMethods::Methods)

            Rulez::class_variable_set(:@@models, nil)
            Rulez::set_models([FakeModel1, FakeModel2, Restaurant])

            v1 = Rulez::Variable.new(name: "MyVariable1Name",
                                    description: "MyVariable1Description",
                                    model: "FakeModel1")
            v1.save!
            v2 = Rulez::Variable.new(name: "MyVariable2Name",
                                    description: "MyVariable2Description",
                                    model: "FakeModel2")
            v2.save!
            v3 = Rulez::Variable.new(name: "first_restaurant",
                                    description: "MyVariable3Description",
                                    model: "Restaurant")
            v3.save!
            
            c1 = Rulez::Context.new(name: "MyContext1Name",
                                    description: "MyContext1Description")
            c1.variables.push(v1,v3)
            c1.save!
            
            r1 = Rulez::Rule.new(name: "MyRule1Name",
                                description: "MyRule1Description",
                                parameters: "p1,p2,p3",
                                rule: "p1 == true && p2 < 15 && p3 != \"MyString\" && first_restaurant.id == 1")
            r1.context = c1
            r1.save!
          end

          after(:each) do
            Rulez::Variable.find(:all).each do |v|
              v.destroy
            end
            Rulez::Context.find(:all).each do |c|
              c.destroy
            end
            Rulez::Rule.find(:all).each do |r|
              r.destroy
            end
          end

          after(:all) do
            Rulez::set_models(@models)
          end

          # # uncomment when discussed on issue #31 and changed the last line of this test consequently
          # it "raises error if a Context contains a reference to inexistent Variable" do
          #   Rulez::Variable.find_by_name("MyVariable1Name").destroy
          #   errors = Rulez::doctor
          #   errors.should_not be_empty
          # end
          
          it "signals error if the Rule contains a reference to inexistent Variable" do
            Rulez::Variable.find_by_name("first_restaurant").destroy
            errors = Rulez::doctor
            errors.should_not be_empty
          end

          it "does not signal errors if all Rules are right" do
            errors = Rulez::doctor
            errors.should be_empty
          end
        end

        describe "errors on Alternatives" do
          before(:all) do
            @models = Rulez::get_models
          end          

          before(:each) do 
            Rulez::class_variable_set(:@@methods_class, nil)
            Rulez::set_methods_class(RulezMethods::Methods)

            Rulez::class_variable_set(:@@models, nil)
            Rulez::set_models([FakeModel1, FakeModel2, Restaurant])

            v1 = Rulez::Variable.new(name: "MyVariable1Name",
                                    description: "MyVariable1Description",
                                    model: "FakeModel1")
            v1.save!
            v2 = Rulez::Variable.new(name: "MyVariable2Name",
                                    description: "MyVariable2Description",
                                    model: "FakeModel2")
            v2.save!
            v3 = Rulez::Variable.new(name: "first_restaurant",
                                    description: "MyVariable3Description",
                                    model: "Restaurant")
            v3.save!
            
            c1 = Rulez::Context.new(name: "MyContext1Name",
                                    description: "MyContext1Description")
            c1.variables.push(v1,v3)
            c1.save!
            
            r1 = Rulez::Rule.new(name: "MyRule1Name",
                                description: "MyRule1Description",
                                parameters: "p1,p2,p3",
                                rule: "true")
            r1.context = c1
            r1.save!

            a1 = Rulez::Alternative.new(description: "MyAlternative1Description",
                                        condition: "true",
                                        alternative: "true")
            a1.rule_id = r1.id
            a1.priority = 1
            a1.save!
          end

          after(:each) do
            Rulez::Variable.find(:all).each do |v|
              v.destroy
            end
            Rulez::Context.find(:all).each do |c|
              c.destroy
            end
            Rulez::Rule.find(:all).each do |r|
              r.destroy
            end
          end

          after(:all) do
            Rulez::set_models(@models)
          end
          
          it "signals error if the Alternative condition field contains a reference to inexistent Variable" do
            a = Rulez::Rule.find_by_name("MyRule1Name").alternatives.first
            a.condition = "p1 == true && p2 < 15 && p3 != \"MyString\" && first_restaurant.id == 1"
            a.alternative = "true"
            a.save!
            Rulez::Variable.find_by_name("first_restaurant").destroy
            errors = Rulez::doctor
            errors.should_not be_empty
          end

          it "signals error if the Alternative alternative field contains a reference to inexistent Variable" do
            a = Rulez::Rule.find_by_name("MyRule1Name").alternatives.first
            a.alternative = "p1 == true && p2 < 15 && p3 != \"MyString\" && first_restaurant.id == 1"
            a.condition = "true"
            a.save!
            Rulez::Variable.find_by_name("first_restaurant").destroy
            errors = Rulez::doctor
            errors.should_not be_empty
          end

          it "does not signal errors if all Alternatives are right" do
            errors = Rulez::doctor
            errors.should be_empty
          end
        end
      end
    end
  end
end