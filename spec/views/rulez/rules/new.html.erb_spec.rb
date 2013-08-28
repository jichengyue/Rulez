# require 'spec_helper'

# describe "rulez/rules/new" do

#   before(:each) do
#     assign(:rule, stub_model(Rulez::Rule,
#       :name => "MyString",
#       :description => "MyText",
#       :rule => "MyText",
#       :parameters => "MyText"
#     ).as_new_record)
#   end

#   it "renders new rule form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form[action=?][method=?]", rules_path, "post" do
#       assert_select "input#rule_name[name=?]", "rule[name]"
#       assert_select "textarea#rule_description[name=?]", "rule[description]"
#       assert_select "textarea#rule_rule[name=?]", "rule[rule]"
#       assert_select "textarea#rule_parameters[name=?]", "rule[parameters]"
#     end
#   end
# end
