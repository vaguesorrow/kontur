require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "shared menu appears on section pages without duplicate navigation" do
    paths = [root_path, pages_about_path, pages_community_path, articles_path,
             pages_faq_path, pages_interactives_path, projects_path, comments_path]
    menu_paths = paths - [projects_path, comments_path]
    paths.each do |path|
      get path
      assert_response :success
      assert_select "nav.menuBar", count: 1 do
        menu_paths.each { |destination| assert_select "a[href=?]", destination, count: 1 }
        assert_select "a[href=?]", projects_path, count: 0
        assert_select "a[href=?]", comments_path, count: 0
        assert_select "a[href=?]", new_user_session_path, text: "Войти"
        assert_select "a[href=?]", new_user_registration_path, text: "Зарегистрироваться"
      end
      assert_select "a[href=?]", pages_about_path, count: 1
    end
  end

  test "signed in menu provides account link and working logout" do
    user = users(:one)
    sign_in user
    get root_path
    assert_select "nav.menuBar" do
      assert_select "a[href=?]", edit_user_registration_path, text: user.email
      assert_select "a[href=?]", new_user_session_path, count: 0
      assert_select "a[href=?]", new_user_registration_path, count: 0
      assert_select "form[action=?][method=post]", destroy_user_session_path do
        assert_select "input[name=_method][value=delete]"
        assert_select "button", text: "Выйти"
      end
    end
    delete destroy_user_session_path
    assert_response :redirect
    get root_path
    assert_select "nav.menuBar a[href=?]", new_user_session_path
  end
end
