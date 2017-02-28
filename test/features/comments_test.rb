require "test_helper"

class CommentsTest < Capybara::Rails::TestCase
  setup do
    @post = create(:published_post)
    @user = create(:user)
    @comment1 = create(:published_post, parent: @post)
    create_list(:post_conversant, 3, post: @post)
  end

  test "User can join the conversation on a post" do
    login_as @user
    visit post_path(@post)
    assert_content @comment1.published_content
    refute_content "Reply"
    click_on "Join the conversation!"
    assert_equals 3, @post.conversants.count
    assert_content "My intention in joining this conversation"
    select "share facts / research / objective knowledge", from: "post_conversant[intention_type]"
    click_on "Join in!"
    # Not yet joined because I didn't submit all required info
    assert_path post_conversants_path
    assert_equals 3, @post.conversants.count
    assert_content "Intention statement can't be blank"
    fill_in "post_conversant[intention_statement]", with: "test blah foo"
    click_button "Join in!"
    assert_path post_path(@post)
    assert_content "We're glad you've joined the discussion! Reply to this post in-line or at the bottom of the page."
    assert_content "Reply" # now can add a reply
    assert_equals 4, @post.conversants.count
    assert @post.conversants.include?(@user)
  end

  test "User can add comments and reply to others' comments" do
    using_webkit do
      create(:post_conversant, user: @user, post: @post) # I've joined the convo

      login_as @user
      visit post_path(@post)
      assert_equals 1, @post.children.not_inline.count
      assert_selector "form.new-bottom-comment", count: 0
      page.find(".js-new-reply[data-post-id=\"#{@post.id}\"]").click
      assert_selector "form.new-bottom-comment", count: 1
      assert_content "Ways to support awesome conversation:"
      fill_in "post[draft_content]", with: "My novel and witty response"
      click_on "Publish reply"
      assert_content "Unable to save your changes. See error messages below."
      select "seek advice", from: "post[intention_type]"
      click_on "Publish reply"
      assert_path post_path(@post)
      assert_content "My novel and witty response"
      assert_equals 2, @post.children.not_inline.count
      @reply = @post.reload.children.last
      assert_equals @user, @reply.author
      assert_equals "My novel and witty response", @reply.published_content
      assert_equals "seek advice", @reply.intention_type
    end
  end
end
