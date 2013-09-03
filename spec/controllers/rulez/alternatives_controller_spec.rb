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
  describe AlternativesController do

    # Load engine routes
    routes{Rulez::Engine.routes}
  
    before(:each) do
      Context.new(name: "MyContextName", description: "MyDescription").save
      @rule = Rule.new(name: "MyRuleName", description: "MyDescription", rule: "true", context_id: Context.last.id)
      @rule.save
    end

    # This should return the minimal set of attributes required to create a valid
    # Alternative. As you add validations to Alternative, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) { { 
      "description" => "MyDescription",
      "condition" => "true",
      "alternative" => "true",
       } }
  
    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # AlternativesController. Be sure to keep this updated too.
    let(:valid_session) { {} }
  
    describe "GET new" do
      it "assigns a new alternative as @alternative" do
        get :new, {rule_id: @rule.id}, valid_session
        assigns(:alternative).should be_a_new(Alternative)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested alternative as @alternative" do
        alternative = create_valid_alternative
        get :edit, {rule_id: @rule.id, :id => alternative.to_param}, valid_session
        assigns(:alternative).should eq(alternative)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Alternative" do
          expect {
            post :create, {rule_id: @rule.id, :alternative => valid_attributes}, valid_session
          }.to change(Alternative, :count).by(1)
        end
  
        it "assigns a newly created alternative as @alternative" do
          post :create, {rule_id: @rule.id, :alternative => valid_attributes}, valid_session
          assigns(:alternative).should be_a(Alternative)
          assigns(:alternative).should be_persisted
        end

        describe "with siblings alternatives" do
          #creates necessary models for testing
          before(:each) do
            @alt1 = create_valid_alternative(1)
            @alt2 = create_valid_alternative(2)
            @rule.alternatives = [@alt1, @alt2]
            @rule.save!
          end

          it "creates a new Alternative with the highest priority compared to his siblings" do
            post :create, {rule_id: @rule.id, :alternative => valid_attributes}, valid_session
            new_alt = assigns(:alternative)
            @rule.reload
            @rule.alternative_ids.should match_array([@alt1.id, @alt2.id, new_alt.id])
            @alt1.priority.should == 1
            @alt2.priority.should == 2
            new_alt.priority.should == 3
          end

          it "should assign priorities in sequence, without duplicates or holes" do
            @alt2.priority = 3
            @alt2.save!

            post :create, {rule_id: @rule.id, :alternative => valid_attributes}, valid_session
            new_alt = assigns(:alternative)
            @rule.reload
            @alt1.reload
            @alt2.reload
            @rule.alternative_ids.should match_array([@alt1.id, @alt2.id, new_alt.id])
            @alt1.priority.should == 1
            @alt2.priority.should == 2
            new_alt.priority.should == 3
          end
        end
  
        it "redirects to the created alternative" do
          post :create, {rule_id: @rule.id, :alternative => valid_attributes}, valid_session
          response.should redirect_to(@rule)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved alternative as @alternative" do
          # Trigger the behavior that occurs when invalid params are submitted
          Alternative.any_instance.stub(:save).and_return(false)
          post :create, {rule_id: @rule.id, :alternative => { "description" => "invalid value" }}, valid_session
          assigns(:alternative).should be_a_new(Alternative)
        end
  
        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Alternative.any_instance.stub(:save).and_return(false)
          post :create, {rule_id: @rule.id, :alternative => { "description" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end
  
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested alternative" do
          alternative = create_valid_alternative
          # Assuming there are no other alternatives in the database, this
          # specifies that the Alternative created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Alternative.any_instance.should_receive(:update_attributes).with({ "description" => "MyString" })
          put :update, {rule_id: @rule.id, :id => alternative.to_param, :alternative => { "description" => "MyString" }}, valid_session
        end
  
        it "assigns the requested alternative as @alternative" do
          alternative = create_valid_alternative
          put :update, {rule_id: @rule.id, :id => alternative.to_param, :alternative => valid_attributes}, valid_session
          assigns(:alternative).should eq(alternative)
        end
  
        it "redirects to the alternative" do
          alternative = create_valid_alternative
          put :update, {rule_id: @rule.id, :id => alternative.to_param, :alternative => valid_attributes}, valid_session
          response.should redirect_to(@rule)
        end
      end
  
      describe "with invalid params" do
        it "assigns the alternative as @alternative" do
          alternative = create_valid_alternative
          # Trigger the behavior that occurs when invalid params are submitted
          Alternative.any_instance.stub(:save).and_return(false)
          put :update, {rule_id: @rule.id, :id => alternative.to_param, :alternative => { "description" => "invalid value" }}, valid_session
          assigns(:alternative).should eq(alternative)
        end
  
        it "re-renders the 'edit' template" do
          alternative = create_valid_alternative
          # Trigger the behavior that occurs when invalid params are submitted
          Alternative.any_instance.stub(:save).and_return(false)
          put :update, {rule_id: @rule.id, :id => alternative.to_param, :alternative => { "description" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested alternative" do
        alternative = create_valid_alternative
        expect {
          delete :destroy, {rule_id: @rule.id, :id => alternative.to_param}, valid_session
        }.to change(Alternative, :count).by(-1)
      end
  
      it "redirects to the alternatives list" do
        alternative = create_valid_alternative
        delete :destroy, {rule_id: @rule.id, :id => alternative.to_param}, valid_session
        response.should redirect_to(@rule)
      end

      it "removes alternative and sorts siblings priority, without duplicates or holes" do
        alt1 = create_valid_alternative(4)
        alt2 = create_valid_alternative(2)
        alt3 = create_valid_alternative(1)
        alt4 = create_valid_alternative(3)

        delete :destroy, {rule_id: @rule.id, :id => alt3.to_param}, valid_session
        @rule.reload
        alt1.reload
        alt2.reload
        alt4.reload
        @rule.alternative_ids.should match_array([alt1.id, alt2.id, alt4.id])
        alt1.priority.should == 3
        alt2.priority.should == 1
        alt4.priority.should == 2
      end
    end
  
    def create_valid_alternative(priority = 1)
      a = Alternative.new(valid_attributes)
      a.rule_id = @rule.id
      a.priority = priority
      a.save!
      a
    end
  end
end
