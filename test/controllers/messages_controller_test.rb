require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test "should get course_navigation" do
    get :course_navigation
    assert_response :success
  end

end
