require 'test_helper'

class ClientFeesControllerTest < ActionController::TestCase
  setup do
    @client_fee = client_fees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_fees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_fee" do
    assert_difference('ClientFee.count') do
      post :create, client_fee: {  }
    end

    assert_redirected_to client_fee_path(assigns(:client_fee))
  end

  test "should show client_fee" do
    get :show, id: @client_fee
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client_fee
    assert_response :success
  end

  test "should update client_fee" do
    put :update, id: @client_fee, client_fee: {  }
    assert_redirected_to client_fee_path(assigns(:client_fee))
  end

  test "should destroy client_fee" do
    assert_difference('ClientFee.count', -1) do
      delete :destroy, id: @client_fee
    end

    assert_redirected_to client_fees_path
  end
end
