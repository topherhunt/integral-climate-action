require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class UsersControllerTest < ActionController::TestCase
  tests UsersController

  context "#index" do
    it "works"
  end

  context "#show" do
    it "renders the user profile correctly" do
      user = create :user
      # Populate some sample content
      create :project, owner: user
      create :conversation, creator: user
      create :resource, creator: user

      get :show, id: user.id
      assert_content user.name
    end
  end
end
