require "test_helper"

class PostTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  test "Blog post lifecycle" do
    visit "/posts/new_form" # FIXME: change to {click_button "New Post"}

    assert_selector "form[action='/posts/create']" # DISCUSS: do we need this?
    assert_selector "form.new_post.simple_form" # make sure we see the correct form.

# New =invalid= no post content written!
    click_on "Submit!"

  # form shows errors
    assert_selector "form.new_post.simple_form" # make sure we see the correct form.
    assert_selector "div.input.post_content.field_with_errors" # field with errors # TODO: test error message?

# New =valid data=
    fill_in :post_content, with: "Are we live?"
    click_on "Submit!"

# Automatically redirected to "View Post"
    assert_selector "h1", text: "View Post" # TODO: introduce headline
    assert_selector ".post_content", text: "Are we live?"

    puts page.body
    # assert_select "form:match('action', ?)", "/posts/new"
    # "div:match('id', ?)", "id_string"
    # assert_response :success
  end
end
