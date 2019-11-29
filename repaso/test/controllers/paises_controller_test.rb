require 'test_helper'

class PaisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @paise = paises(:one)
  end

  test "should get index" do
    get paises_url
    assert_response :success
  end

  test "should get new" do
    get new_paise_url
    assert_response :success
  end

  test "should create paise" do
    assert_difference('Paise.count') do
      post paises_url, params: { paise: { nombre: @paise.nombre } }
    end

    assert_redirected_to paise_url(Paise.last)
  end

  test "should show paise" do
    get paise_url(@paise)
    assert_response :success
  end

  test "should get edit" do
    get edit_paise_url(@paise)
    assert_response :success
  end

  test "should update paise" do
    patch paise_url(@paise), params: { paise: { nombre: @paise.nombre } }
    assert_redirected_to paise_url(@paise)
  end

  test "should destroy paise" do
    assert_difference('Paise.count', -1) do
      delete paise_url(@paise)
    end

    assert_redirected_to paises_url
  end
end
