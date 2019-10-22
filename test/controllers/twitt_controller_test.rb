require 'test_helper'

class TwittControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get twitt_top_url
    assert_response :success
  end

  test "should get create" do
    get twitt_create_url
    assert_response :success
  end

end
