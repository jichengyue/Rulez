require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

module Rulez
  describe RulesController do
    routes { Rulez::Engine.routes }

    before(:each) do
      Context.new(name: "MyContextName", description: "MyContextDescription").save
    end

    # This should return the minimal set of attributes required to create a valid
    # Rule. As you add validations to Rule, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {{ 
      "name" => "MyName",
      "description" => "MyDescription",
      "rule" => "true",
      "context_id" => Context.last.id
    }}

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # RulesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all rules as @rules" do
        Rule.create! valid_attributes
        rules = Rule.all
        get :index, {}, valid_session
        assigns(:rules).should eq(rules)
      end
    end

    describe "GET show" do
      it "assigns the requested rule as @rule" do
        rule = Rule.create! valid_attributes
        get :show, {:id => rule.to_param}, valid_session
        assigns(:rule).should eq(rule)
      end
    end

    describe "GET new" do
      it "assigns a new rule as @rule" do
        get :new, {}, valid_session
        assigns(:rule).should be_a_new(Rule)
      end
    end

    describe "GET edit" do
      it "assigns the requested rule as @rule" do
        rule = Rule.create! valid_attributes
        get :edit, {:id => rule.to_param}, valid_session
        assigns(:rule).should eq(rule)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Rule" do
          expect {
            post :create, {:rule => valid_attributes}, valid_session
          }.to change(Rule, :count).by(1)
        end

        it "assigns a newly created rule as @rule" do
          post :create, {:rule => valid_attributes}, valid_session
          assigns(:rule).should be_a(Rule)
          assigns(:rule).should be_persisted
        end

        it "redirects to the created rule" do
          post :create, {:rule => valid_attributes}, valid_session
          response.should redirect_to(Rule.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved rule as @rule" do
          # Trigger the behavior that occurs when invalid params are submitted
          Rule.any_instance.stub(:save).and_return(false)
          post :create, {:rule => { "name" => "invalid value" }}, valid_session
          assigns(:rule).should be_a_new(Rule)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Rule.any_instance.stub(:save).and_return(false)
          post :create, {:rule => { "name" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested rule" do
          rule = Rule.create! valid_attributes
          # Assuming there are no other rules in the database, this
          # specifies that the Rule created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Rule.any_instance.should_receive(:update_attributes).with(
            { 
              "name" => "MyNewName",
              "description" => "MyNewDescription",
              "rule" => "true || true",
              "context_id" => Context.first.id.to_s
            })
          put :update, 
            {
              :id => rule.to_param, 
              :rule => { 
                "name" => "MyNewName",
                "description" => "MyNewDescription",
                "rule" => "true || true",
                "context_id" => Context.first.id.to_s
              }
            }, 
            valid_session
        end

        it "assigns the requested rule as @rule" do
          rule = Rule.create! valid_attributes
          put :update, {:id => rule.to_param, :rule => valid_attributes}, valid_session
          assigns(:rule).should eq(rule)
        end

        it "redirects to the rule" do
          rule = Rule.create! valid_attributes
          put :update, {:id => rule.to_param, :rule => valid_attributes}, valid_session
          response.should redirect_to(rule)
        end
      end

      describe "with invalid params" do
        it "assigns the rule as @rule" do
          rule = Rule.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Rule.any_instance.stub(:save).and_return(false)
          put :update, {:id => rule.to_param, :rule => { "name" => "invalid value" }}, valid_session
          assigns(:rule).should eq(rule)
        end

        it "re-renders the 'edit' template" do
          rule = Rule.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Rule.any_instance.stub(:save).and_return(false)
          put :update, {:id => rule.to_param, :rule => { "name" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested rule" do
        rule = Rule.create! valid_attributes
        expect {
          delete :destroy, {:id => rule.to_param}, valid_session
        }.to change(Rule, :count).by(-1)
      end

      it "redirects to the rules list" do
        rule = Rule.create! valid_attributes
        delete :destroy, {:id => rule.to_param}, valid_session
        response.should redirect_to(rules_url)
      end
    end

    describe "POST sort_alternatives" do
      before(:each) do
        @rule1 = Rule.create! valid_attributes
        @rule2 = Rule.new valid_attributes
        @rule2.name = "Rule2Name"
        @rule2.save!
        8.times do |n|
          alt = Alternative.new(description: "alt" + n.to_s + "Desc", condition: "true", alternative: "true")
          alt.priority = n%4 + 1
          if n < 4
            @rule1.alternatives << alt
          else
            @rule2.alternatives << alt
          end
        end
        @rule1.save!
        @rule2.save!
      end

      it "correctly sorts the alternatives if params[:order] contains exactly its alternative_ids" do
        old_alternatives = @rule1.alternatives
        new_alternatives = [old_alternatives[2], old_alternatives[0], old_alternatives[3], old_alternatives[1]]
        new_order = "alternative" + new_alternatives.map { |a| a.id.to_s }.join(",alternative")
        get :sort_alternatives, {id: @rule1.to_param, order: new_order}, valid_session

        response.should be_success
        response.body.include?("OK").should be_true
        @rule1.reload
        @rule1.alternatives.sort { |a, b| a.priority <=> b.priority }.should match_array(new_alternatives)
        @rule1.alternatives.sort { |a, b| a.priority <=> b.priority }.should_not == old_alternatives
      end

      it "should not sort the alternatives if params[:order] contains alternative_ids not belonging to the rule" do
        old_alternatives = @rule1.alternatives
        new_alternatives = [old_alternatives[2], old_alternatives[0], old_alternatives[3], @rule2.alternatives[1],old_alternatives[1]]
        new_order = "alternative" + new_alternatives.map { |a| a.id.to_s }.join(",alternative")
        get :sort_alternatives, {id: @rule1.to_param, order: new_order}, valid_session

        response.should be_success
        response.body.include?("ERROR").should be_true
        @rule1.reload
        @rule1.alternatives.sort { |a, b| a.priority <=> b.priority }.should match_array(old_alternatives)
        @rule1.alternatives.sort { |a, b| a.priority <=> b.priority }.should_not == new_alternatives
      end

      it "should not sort the alternatives if params[:order] does not contains all the alternative_ids belonging to the rule" do
        old_alternatives = @rule1.alternatives
        new_alternatives = [old_alternatives[2], old_alternatives[0], old_alternatives[3]]
        new_order = "alternative" + new_alternatives.map { |a| a.id.to_s }.join(",alternative")
        get :sort_alternatives, {id: @rule1.to_param, order: new_order}, valid_session

        response.should be_success
        response.body.include?("ERROR").should be_true
        @rule1.reload
        @rule1.alternatives.sort { |a, b| a.priority <=> b.priority }.should match_array(old_alternatives)
        @rule1.alternatives.sort { |a, b| a.priority <=> b.priority }.should_not == new_alternatives
      end
    end

    describe "redirects to AccessDenied when not authenticated" do
      before(:all) do
        auth_rule = Rule.find_by_name("admin_rulez")
        auth_rule.rule = "false"
        auth_rule.save!
      end

      after(:all) do
        auth_rule = Rule.find_by_name("admin_rulez")
        auth_rule.rule = "true"
        auth_rule.save!
      end

      it "GET index" do
        get :index, {}, valid_session
        response.should redirect_to("/rulez/accessdenied")
      end

      it "GET new" do
        get :new, {}, valid_session
        response.should redirect_to("/rulez/accessdenied")
      end

      it "GET edit" do
        rule = Rule.create! valid_attributes
        get :edit, {:id => rule.to_param}, valid_session
        response.should redirect_to("/rulez/accessdenied")
      end

      it "POST create" do
        post :create, {:rule => valid_attributes}, valid_session
        response.should redirect_to("/rulez/accessdenied")
      end

      it "PUT update" do
        rule = Rule.create! valid_attributes
        get :edit, {:id => rule.to_param}, valid_session
        response.should redirect_to("/rulez/accessdenied")
      end

      it "DELETE destroy" do
        rule = Rule.create! valid_attributes
        delete :destroy, {:id => rule.to_param}, valid_session
        response.should redirect_to("/rulez/accessdenied")
      end
    end
  end
end
