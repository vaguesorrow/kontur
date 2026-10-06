require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pages_index_url
    assert_response :success
  end

  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test "articles links to the other pages" do
    get articles_url
    assert_response :success
    assert_select "h1", "Статьи"
    [root_path, pages_about_path, pages_community_path, pages_faq_path, pages_interactives_path].each do |path|
      assert_select "a[href=?]", path
    end
  end

  test "faq links to the other pages" do
    get pages_faq_url
    assert_response :success
    assert_select "h1", "FAQ"
    [root_path, pages_about_path, pages_community_path, articles_path].each do |path|
      assert_select "a[href=?]", path
    end
  end

  test "other pages link to faq" do
    [root_url, pages_about_url, pages_community_url, articles_url].each do |url|
      get url
      assert_response :success
      assert_select "a[href=?]", pages_faq_path, text: "FAQ"
    end
  end

  test "interactives links to the other pages" do
    get pages_interactives_url
    assert_response :success
    assert_select "h1", "Интерактивы"
    [root_path, pages_about_path, pages_community_path, articles_path, pages_faq_path].each do |path|
      assert_select "a[href=?]", path
    end
  end

  test "other pages link to interactives" do
    [root_url, pages_about_url, pages_community_url, articles_url, pages_faq_url].each do |url|
      get url
      assert_response :success
      assert_select "a[href=?]", pages_interactives_path, text: "Интерактивы"
    end
  end

  test "other pages link to articles" do
    [root_url, pages_about_url, pages_community_url, pages_faq_url, pages_interactives_url].each do |url|
      get url
      assert_response :success
      assert_select "a[href=?]", articles_path, text: "Статьи"
    end
  end
end
