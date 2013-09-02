require "spec_helper"

module Rulez
  describe Variable do

    # This should return the minimal set of attributes required to create a valid
    # Variable. As you add validations to Variable, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {{ 
      "name" => "MyName",
      "description" => "MyDescription",
      "model" => "MyModel"
    }}
  
    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # VariablesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    before(:each) do
      @variable = Variable.new valid_attributes
    end

    # Validation and creation
    context "with valid attributes" do
      it "validates a Variable" do
        @variable.should be_valid
      end

      it "saves a new Variable" do
        @variable.save.should be_true
      end
    end

    # Deletion and modify
    context "with existent Variable" do
      before(:each) do
        @variable.save
      end

      it "should destroy it" do
        count = Variable.count
        @variable.destroy
        Variable.count.should == count-1
      end

      it "should modify all its fields" do
        @variable.name = "MyNewName"
        @variable.save.should be_true

        @variable.description = "MyNewDescription"
        @variable.save.should be_true

        @variable.model = "MyNewModel"
        @variable.save.should be_true
      end
    end

    # Checks all validations
    context "with invalid attributes" do
      it "should not validate a Variable without name" do
        #nil name
        @variable.name = nil
        @variable.valid?.should be_false

        #blank name
        @variable.name = "   "
        @variable.valid?.should be_false
      end

      it "should not validate a Variable with name already taken" do
        @variable.save
        other_variable = Variable.new valid_attributes
        other_variable.valid?.should be_false
      end
    end

  end
end