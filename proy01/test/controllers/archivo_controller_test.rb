require 'test_helper'

class ArchivoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get archivo_index_url
    assert_response :success
  end

  test "should get read" do
    get archivo_read_url
    assert_response :success
  end

end
