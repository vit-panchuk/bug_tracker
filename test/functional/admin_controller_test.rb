require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get logined" do
    get :logined
    assert_response :success
  end

end
