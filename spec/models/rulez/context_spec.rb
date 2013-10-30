# == Schema Information
#
# Table name: rulez_contexts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

module Rulez
  describe Context do
    
    let(:valid_attributes_context) {{
      name: "MyName",
      description: "MyDescription"
    }}

    let(:invalid_attributes_context) {{
      name: nil,
      description: nil
    }}

    let(:valid_attributes_variables) {{ 
      name: "MyName",
      description: "MyDescription",
      model: "MyModel"
    }}

    let(:valid_session) { {} }

    context "Validation and Creation" do

      describe "with valid attributes" do

        before(:each) { @context = Context.new(valid_attributes_context) }

        it "validates a Context" do
          @context.should be_valid
        end

        it "saves a new Context without Variables" do
          @context.save.should be_true
        end

        it "saves a new Context with existent Variables" do
          v = Variable.new(valid_attributes_variables)
          v.save
          @context.variables.push(v)
          @context.save
          @context.variables.should_not be_empty
        end

        it "does not save a new Context if another Context has the same name" do
          Context.new(valid_attributes_context).save
          @context.save.should be_false
        end
      end

      describe "with invalid attributes" do

        before(:each) { @context = Context.new(invalid_attributes_context) }

        it "does not save a new Context without name" do
          @context.description = "MyDescription"
          @context.save.should_not be_true
        end

        it "does not save a new Context without description" do
          @context.name = "MyName"
          @context.save.should_not be_true
        end

        it "does not save a new Context if has an inexistent Variable" do
          v = Variable.new(valid_attributes_variables)
          @context.variables.push(v)
          @context.save.should_not be_true
        end
      end
    end

    context "Deletion" do

      before(:each) do
        @context = Context.new(valid_attributes_context)
        @context.save
      end

      it "destroys an existent Context" do
        n = Context.all.length
        @context.destroy
        Context.all.length.should be_equal(n-1)
      end

      it "destroys only the context and not the Variables associated" do
        v1 = Variable.new(valid_attributes_variables)
        v2 = Variable.new(valid_attributes_variables)
        v3 = Variable.new(valid_attributes_variables)
        v1.save
        v2.save
        v3.save
        n_vars = Variable.all.length
        @context.variables.push(v1)
        @context.variables.push(v3)
        @context.save
        @context.delete
        Variable.all.length.should be_equal(n_vars)
      end
    end

    context "Modification" do
      before(:each) do
        @context = Context.new(valid_attributes_context)
        @context.save
      end

      it "edits the name field" do
        @context.name = "MyNewName"
        @context.save.should be_true
      end

      it "edits the description field" do
        @context.description = "MyNewDescription"
        @context.save.should be_true
      end
    end

  end
end
