require "spec_helper"

module Rulez
  describe Variable do

    # This should return the minimal set of attributes required to create a valid
    # Variable. As you add validations to Variable, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {{ 
      "name" => "MyName",
      "description" => "MyDescription",
      "model" => "Restaurant"
    }}
  
    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # VariablesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    before(:each) do
      @variable = Variable.new valid_attributes
    end

    # Validation and creation
    describe "with valid attributes" do
      it "validates a Variable" do
        @variable.should be_valid
      end

      it "saves a new Variable" do
        @variable.save.should be_true
      end
    end

    # Deletion and modify
    describe "with existent Variable" do
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

        @variable.model = "User"
        @variable.save.should be_true
      end
    end

    # Checks all validations
    describe "with invalid attributes" do
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
        other_variable = Variable.new
        other_variable.name = @variable.name
        other_variable.description = "OtherDescription"
        other_variable.model = "User"
        other_variable.valid?.should be_false
      end

      it "should not validate a Variable without description" do
        #nil description
        @variable.description = nil
        @variable.valid?.should be_false

        #blank description
        @variable.description = "   "
        @variable.valid?.should be_false
      end

      it "should not validate a Variable without model" do
        #nil model
        @variable.model = nil
        @variable.valid?.should be_false

        #blank model
        @variable.model = "   "
        @variable.valid?.should be_false
      end

      it "should not validate a Variable that reference a non-existent model" do
        @variable.model = "NonExistentModel"
        @variable.valid?.should be_false
      end

    end

  end
end