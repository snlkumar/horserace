require 'test_helper'

class BankDetailsControllerTest < ActionController::TestCase
  setup do
    @bank_detail = bank_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bank_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bank_detail" do
    assert_difference('BankDetail.count') do
      post :create, bank_detail: { account: @bank_detail.account, account_name: @bank_detail.account_name, bank_name: @bank_detail.bank_name, bsb: @bank_detail.bsb }
    end

    assert_redirected_to bank_detail_path(assigns(:bank_detail))
  end

  test "should show bank_detail" do
    get :show, id: @bank_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bank_detail
    assert_response :success
  end

  test "should update bank_detail" do
    put :update, id: @bank_detail, bank_detail: { account: @bank_detail.account, account_name: @bank_detail.account_name, bank_name: @bank_detail.bank_name, bsb: @bank_detail.bsb }
    assert_redirected_to bank_detail_path(assigns(:bank_detail))
  end

  test "should destroy bank_detail" do
    assert_difference('BankDetail.count', -1) do
      delete :destroy, id: @bank_detail
    end

    assert_redirected_to bank_details_path
  end
end
