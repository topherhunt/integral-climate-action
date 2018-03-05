require "test_helper"

class UserProfileTest < Capybara::Rails::TestCase
  setup do
    @user = create :user
  end

  test "user profile viewing & editing works" do
    visit root_path
    login_as @user

    # editing my profile
    click_on "My Profile"
    page.find(".test-edit-user").click
    fill_in "user_first_name", with: "Elmer"
    page.find(".test-submit-user-profile").click
    assert_equals "Elmer", @user.reload.first_name

    # viewing my profile
    # TODO
  end
end
