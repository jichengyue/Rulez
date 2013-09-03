require 'spec_helper'

module Rulez
  describe Alternative do

    let(:valid_attributes_alternative) {{
      description: "MyDescription",
      condition: "true",
      alternative: "true",
      priority: 1,
    }}

    let(:valid_attributes_variable) {{ 
      name: "MyName",
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
      before (:each) do
        v = Variable.new(valid_attributes_variable)
        v.save
        c = Context.new(valid_attributes_context)
        c.variables.push(v)
        c.save
        r = Rule.new(valid_attributes_rule)
        r.context = c
        r.save
      end
    end

  end
end
