require 'test_helper'

class RubrosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rubros_index_url
    assert_response :success
  end

  test "should get new" do
    get rubros_new_url
    assert_response :success
  end

  test "should get edit" do
    get rubros_edit_url
    assert_response :success
  end

  test "should get create" do
    get rubros_create_url
    assert_response :success
  end

  test "should get update" do
    get rubros_update_url
    assert_response :success
  end

  test "should get delete" do
    get rubros_delete_url
    assert_response :success
  end

end
