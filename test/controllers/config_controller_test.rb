require 'test_helper'

class ConfigControllerTest < ActionController::TestCase
  test "should get xml_config" do
    get :xml_config
    assert_response :success
  end

end
