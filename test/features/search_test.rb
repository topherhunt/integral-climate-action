require "test_helper"

class SearchTest < Capybara::Rails::TestCase
  setup do
    @user1 = create :user
    @project1 = create :project, title: "Apple Bear"
    @resource1 = create :resource, title: "Bear Cat"
    @post1 = create :published_post, title: "Cat Dog"
    @post2 = create :published_post, title: "Dog Elephant"
    @draft = create :draft_post, title: "Bear bear"
    reindex_elasticsearch!
  end

  test "search interface works" do
    visit root_path

    # searching from navbar
    page.find(".test-navbar-search-input").set("bear")
    page.find(".test-navbar-search-submit").click
    assert_path search_path
    assert_content @project1.title
    assert_html project_path(@project1)
    assert_content @resource1.title
    assert_no_content @user1.full_name
    assert_no_content @post1.title
    assert_no_content @post2.title
    assert_no_content @draft.title

    # searching from the results page form
    page.find(".test-search-input").set("cat")
    page.find(".test-search-submit").click
    assert_content @post1.title
    assert_content @resource1.title
    assert_no_content @post2.title
    assert_no_content @user1.full_name
    assert_no_content @project1.title
  end
end
