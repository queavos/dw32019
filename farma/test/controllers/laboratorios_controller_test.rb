require 'test_helper'

class LaboratoriosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get laboratorios_index_url
    assert_response :success
  end

  test "should get new" do
    get laboratorios_new_url
    assert_response :success
  end

  test "should get create" do
    get laboratorios_create_url
    assert_response :success
  end

  test "should get edit" do
    get laboratorios_edit_url
    assert_response :success
  end

  test "should get update" do
    get laboratorios_update_url
    assert_response :success
  end

  test "should get delete" do
    get laboratorios_delete_url
    assert_response :success
  end

end
