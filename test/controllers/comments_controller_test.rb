require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @comment = comments(:one)
    sign_in @comment.user
  end

  test "should get index" do
    get comments_url
    assert_response :success
  end

  test "adds comment to article using signed in author and route article" do
    assert_difference("Comment.count", 1) do
      post article_comments_url(@comment.article), params: {
        comment: { body: "Мой комментарий", user_id: users(:two).id, article_id: articles(:two).id }
      }
    end
    created = Comment.last
    assert_equal @comment.user, created.user
    assert_equal @comment.article, created.article
    assert_redirected_to article_url(@comment.article, anchor: "comments")
    follow_redirect!
    assert_select "#comments", text: /Мой комментарий/
    assert_select "form[action=?] textarea[name='comment[body]']", article_comments_path(@comment.article)
    assert_select "#comments input[name='comment[user_id]']", count: 0
  end

  test "rejects blank comment and renders article with errors" do
    assert_no_difference("Comment.count") do
      post article_comments_url(@comment.article), params: { comment: { body: "   " } }
    end
    assert_response :unprocessable_content
    assert_select "#comments [role=alert]", text: /Комментарий не может быть пустым/
    assert_select "#comments form[action=?]", article_comments_path(@comment.article)
  end

  test "guest can read comments but cannot add them" do
    sign_out @comment.user
    get article_url(@comment.article)
    assert_response :success
    assert_select "#comments", text: /#{Regexp.escape(@comment.body)}/
    assert_select "#comments a[href=?]", new_user_session_path
    assert_select "#comments textarea", count: 0
    assert_no_difference("Comment.count") do
      post article_comments_url(@comment.article), params: { comment: { body: "Guest comment" } }
    end
    assert_redirected_to new_user_session_url
  end

  test "cannot modify another users comment" do
    sign_in users(:two)
    patch comment_url(@comment), params: { comment: { body: "Changed" } }
    assert_response :forbidden
    assert_equal "MyText", @comment.reload.body
    assert_no_difference("Comment.count") { delete comment_url(@comment) }
    assert_response :forbidden
  end

  test "should get new" do
    get new_comment_url
    assert_response :success
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post comments_url, params: { comment: { article_id: @comment.article_id, body: @comment.body, user_id: @comment.user_id } }
    end

    assert_redirected_to article_url(@comment.article, anchor: "comments")
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "should update comment" do
    patch comment_url(@comment), params: { comment: { article_id: @comment.article_id, body: @comment.body, user_id: @comment.user_id } }
    assert_redirected_to comment_url(@comment)
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to comments_url
  end
end
