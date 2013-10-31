# == Schema Information
#
# Table name: rulez_alternatives
#
#  id          :integer          not null, primary key
#  description :string(255)
#  condition   :text
#  alternative :text
#  rule_id     :integer
#  priority    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

module Rulez
  describe Alternative do

    let(:valid_attributes_alternative) {{
      description: "MyDescription",
      condition: "true",
      alternative: "true"
    }}

    let(:valid_attributes_variable) {{ 
      name: "first_restaurant",
      description: "MyDescription",
      model:"Restaurant"
    }}

    let(:valid_attributes_context) {{
      name: "MyName",
      description: "MyDescription"
    }}

    let(:valid_attributes_rule) {{
      name: "MyName",
      description: "MyDescription",
      rule: "true",
      parameters: "p1,p2,p3"
    }}

    context "Creation and Validation" do

      before(:each) do
        @v = Variable.new(valid_attributes_variable)
        @v.save
        @c = Context.new(valid_attributes_context)
        @c.variables.push(@v)
        @c.save
        @r = Rule.new(valid_attributes_rule)
        @r.context = @c
        @r.save
        @alternative = Alternative.new(valid_attributes_alternative)
        @alternative.priority = 1
        @r.alternatives.push(@alternative)
      end


      it "validates an Alternative with description, condition, alternative and priority" do
        @alternative.should be_valid
      end

      it "does not validate without description field" do
        @alternative.description = nil
        @alternative.should_not be_valid
      end
      
      it "does not validate without condition field" do
        @alternative.condition = nil
        @alternative.should_not be_valid
      end

      it "does not validate syntactically wrong condition field" do
        @alternative.condition = "MyWrongExpression"
        @alternative.should_not be_valid
      end

      it "validates with Parameters on condition" do
        @alternative.condition = "p1 == true && (p2 <= 20 || p2 >= 30.5) && p3 == \"MyString\""
        @alternative.should be_valid
      end

      it "does not validate with inexistent Parameters on condition" do
        @alternative.condition = "p4 == 76.3"
        @alternative.should_not be_valid
      end

      it "validates with existent Variable on condition" do
        @alternative.condition = "first_restaurant.name == \"MyRestaurantName\""
        @alternative.should be_valid
      end

      it "does not validate with inexistent Variable on condition" do
        @alternative.condition = "first_restaurant.my_inexistent_symbol_on_model == \"MyValue\""
        @alternative.should_not be_valid
      end

      it "validates with existent Function on condition" do
        @alternative.condition = "thetruth == true"
        @alternative.should be_valid
      end

      it "deos not validate with inexistent Function on condition" do
        @alternative.condition = "MyInexistentFunction == true"
        @alternative.should_not be_valid
      end

      it "does not validate without alternative field" do
        @alternative.alternative = nil
        @alternative.should_not be_valid
      end

      it "does not validate syntactically wrong alternative field" do
        @alternative.alternative = "MyWrongExpression"
        @alternative.should_not be_valid
      end

      it "validates with Parameters on alternative" do
        @alternative.alternative = "p1 == true && (p2 <= 20 || p2 >= 30.5) && p3 == \"MyString\""
        @alternative.should be_valid
      end

      it "does not validate with inexistent Parameters on alternative" do
        @alternative.alternative = "p4 == 76.3"
        @alternative.should_not be_valid
      end

      it "validates with existent Variable on alternative" do
        @alternative.alternative = "first_restaurant.name == \"MyRestaurantName\""
        @alternative.should be_valid
      end

      it "does not validate with inexistent Variable on alternative" do
        @alternative.alternative = "first_restaurant.my_inexistent_symbol_on_model == \"MyValue\""
        @alternative.should_not be_valid
      end

      it "validates with existent Function on alternative" do
        @alternative.alternative = "thetruth == true"
        @alternative.should be_valid
      end

      it "deos not validate with inexistent Function on alternative" do
        @alternative.alternative = "MyInexistentFunction == true"
        @alternative.should_not be_valid
      end

      it "does not validate without a rule associated" do
        @alternative.rule_id = nil
        @alternative.should_not be_valid
      end

      it "does not validate without an existing rule associated" do
        r = Rule.find(@alternative.rule_id)
        r.should_not be_nil
      end

      it "does not validate without a priority" do
        @alternative.priority = nil
        @alternative.should_not be_valid
      end

      it "has numerical priority field" do
        @alternative.priority.class.should be_equal(Fixnum)
      end

      it "has the same parameters of the parent rule" do
        pl = @r.get_parameters_list
        @alternative.get_parameters_list.should match_array(pl)
      end
    end

    context "Deletion" do
      before(:each) do
        @v = Variable.new(valid_attributes_variable)
        @v.save
        @c = Context.new(valid_attributes_context)
        @c.variables.push(@v)
        @c.save
        @r = Rule.new(valid_attributes_rule)
        @r.context = @c
        @r.save
        @alternative = Alternative.new(valid_attributes_alternative)
        @alternative.priority = 1
        @r.alternatives.push(@alternative)
        @alternative.save
        @r.save
      end

      it "destroys an existent Alternative" do
        na = @r.alternatives.length
        @alternative.destroy
        @r.reload
        @r.alternatives.length.should be_equal(na-1)
      end
    end

    context "Modification" do
      before(:each) do
        @v = Variable.new(valid_attributes_variable)
        @v.save
        @c = Context.new(valid_attributes_context)
        @c.variables.push(@v)
        @c.save
        @r = Rule.new(valid_attributes_rule)
        @r.context = @c
        @r.save
        @alternative = Alternative.new(valid_attributes_alternative)
        @alternative.priority = 1
        @r.alternatives.push(@alternative)
        @alternative.save
        @r.save
      end

      it "edits the description field" do
        @alternative.description = "MyNewDescription"
        @alternative.save.should be_true
      end

      it "edits the condition field" do
        @alternative.condition = "false"
        @alternative.save.should be_true
      end

      it "edits the alternative field" do
        @alternative.alternative = "false"
        @alternative.save.should be_true
      end

      it "edits priority field" do
        @alternative.priority = 2
        @alternative.save.should be_true
      end

    end

  end
end
