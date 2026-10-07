require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @article = articles(:one)
    sign_in @article.user
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
    assert_select "input[name='article[user_id]']", count: 0
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { body: @article.body, cover_url: @article.cover_url, published: @article.published, title: @article.title } }
    end

    assert_redirected_to article_url(Article.last)
    assert_equal @article.user, Article.last.user
  end

  test "uses signed in author even when another user id is submitted" do
    post articles_url, params: { article: { title: "New article", body: "Body", user_id: users(:two).id } }

    assert_redirected_to article_url(Article.last)
    assert_equal @article.user, Article.last.user
  end

  test "guest cannot create article" do
    sign_out @article.user
    get new_article_url
    assert_redirected_to new_user_session_url

    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "Guest article", body: "Body" } }
    end
    assert_redirected_to new_user_session_url
  end

  test "updating article cannot change its author" do
    patch article_url(@article), params: { article: { title: "Updated", user_id: users(:two).id } }

    assert_redirected_to article_url(@article)
    assert_equal users(:one), @article.reload.user
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { body: @article.body, cover_url: @article.cover_url, published: @article.published, title: @article.title, user_id: @article.user_id } }
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    comment_ids = @article.comments.pluck(:id)
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
    assert_empty Comment.where(id: comment_ids)
  end
end
