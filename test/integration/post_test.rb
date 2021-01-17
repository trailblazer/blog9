require "test_helper"

class PostTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  test "Blog post lifecycle" do
    visit "/posts/new_form" # FIXME: change to {click_button "New Post"}

    assert_selector "div", text: "yo"
    # assert_response :success
  end
end
