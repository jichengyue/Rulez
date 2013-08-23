require 'test_helper'

module Rulez
  class AlternativesControllerTest < ActionController::TestCase
    setup do
      @alternative = alternatives(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:alternatives)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create alternative" do
      assert_difference('Alternative.count') do
        post :create, alternative: { alternative: @alternative.alternative, condition: @alternative.condition, description: @alternative.description }
      end

      assert_redirected_to alternative_path(assigns(:alternative))
    end

    test "should show alternative" do
      get :show, id: @alternative
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @alternative
      assert_response :success
    end

    test "should update alternative" do
      patch :update, id: @alternative, alternative: { alternative: @alternative.alternative, condition: @alternative.condition, description: @alternative.description }
      assert_redirected_to alternative_path(assigns(:alternative))
    end

    test "should destroy alternative" do
      assert_difference('Alternative.count', -1) do
        delete :destroy, id: @alternative
      end

      assert_redirected_to alternatives_path
    end
  end
end
