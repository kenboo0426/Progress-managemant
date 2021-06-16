require "test_helper"

class RedmineControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get redmine_index_url
    assert_response :success
  end

  test "should get show" do
    get redmine_show_url
    assert_response :success
  end
end
