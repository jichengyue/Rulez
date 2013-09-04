require "spec_helper.rb"

class FakeMethodsClass
end

module FakeModule
end

class FakeModel1 < ActiveRecord::Base
end

class FakeModel2 < ActiveRecord::Base
end

module Rulez
  describe Rulez do
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
end