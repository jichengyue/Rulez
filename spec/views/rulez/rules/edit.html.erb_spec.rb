# require 'spec_helper'

# describe "rulez/rules/edit" do

#   before(:each) do
#     @rule = assign(:rule, stub_model(Rulez::Rule,
#       :name => "MyString",
#       :description => "MyText",
#       :rule => "MyText",
#       :parameters => "MyText"
#     ))
#   end

#   it "renders the edit rule form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form[action=?][method=?]", rule_path(@rule), "post" do
#       assert_select "input#rule_name[name=?]", "rule[name]"
#       assert_select "textarea#rule_description[name=?]", "rule[description]"
#       assert_select "textarea#rule_rule[name=?]", "rule[rule]"
#       assert_select "textarea#rule_parameters[name=?]", "rule[parameters]"
#     end
#   end
# end
