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
  describe VariablesController do
    routes {Rulez::Engine.routes}
  
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
  
    describe "GET index" do
      it "assigns all variables as @variables" do
        variable = Variable.create! valid_attributes
        get :index, {}, valid_session
        assigns(:variables).should eq([variable])
      end
    end
  
    describe "GET show" do
      it "assigns the requested variable as @variable" do
        variable = Variable.create! valid_attributes
        get :show, {:id => variable.to_param}, valid_session
        assigns(:variable).should eq(variable)
      end
    end
  
    describe "GET new" do
      it "assigns a new variable as @variable" do
        get :new, {}, valid_session
        assigns(:variable).should be_a_new(Variable)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested variable as @variable" do
        variable = Variable.create! valid_attributes
        get :edit, {:id => variable.to_param}, valid_session
        assigns(:variable).should eq(variable)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Variable" do
          expect {
            post :create, {:variable => valid_attributes}, valid_session
          }.to change(Variable, :count).by(1)
        end
  
        it "assigns a newly created variable as @variable" do
          post :create, {:variable => valid_attributes}, valid_session
          assigns(:variable).should be_a(Variable)
          assigns(:variable).should be_persisted
        end
  
        it "redirects to the created variable" do
          post :create, {:variable => valid_attributes}, valid_session
          response.should redirect_to(Variable.last)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved variable as @variable" do
          # Trigger the behavior that occurs when invalid params are submitted
          Variable.any_instance.stub(:save).and_return(false)
          post :create, {:variable => { "name" => "invalid value" }}, valid_session
          assigns(:variable).should be_a_new(Variable)
        end
  
        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Variable.any_instance.stub(:save).and_return(false)
          post :create, {:variable => { "name" => "invalid value" }}, valid_session
          response.should render_template("new")
        end
      end
    end
  
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested variable" do
          variable = Variable.create! valid_attributes
          # Assuming there are no other variables in the database, this
          # specifies that the Variable created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Variable.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
          put :update, {:id => variable.to_param, :variable => { "name" => "MyString" }}, valid_session
        end
  
        it "assigns the requested variable as @variable" do
          variable = Variable.create! valid_attributes
          put :update, {:id => variable.to_param, :variable => valid_attributes}, valid_session
          assigns(:variable).should eq(variable)
        end
  
        it "redirects to the variable" do
          variable = Variable.create! valid_attributes
          put :update, {:id => variable.to_param, :variable => valid_attributes}, valid_session
          response.should redirect_to(variable)
        end
      end
  
      describe "with invalid params" do
        it "assigns the variable as @variable" do
          variable = Variable.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Variable.any_instance.stub(:save).and_return(false)
          put :update, {:id => variable.to_param, :variable => { "name" => "invalid value" }}, valid_session
          assigns(:variable).should eq(variable)
        end
  
        it "re-renders the 'edit' template" do
          variable = Variable.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Variable.any_instance.stub(:save).and_return(false)
          put :update, {:id => variable.to_param, :variable => { "name" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested variable" do
        variable = Variable.create! valid_attributes
        expect {
          delete :destroy, {:id => variable.to_param}, valid_session
        }.to change(Variable, :count).by(-1)
      end
  
      it "redirects to the variables list" do
        variable = Variable.create! valid_attributes
        delete :destroy, {:id => variable.to_param}, valid_session
        response.should redirect_to(variables_url)
      end
    end
  
  end
end
