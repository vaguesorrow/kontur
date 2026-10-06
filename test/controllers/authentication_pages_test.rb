require "test_helper"

class AuthenticationPagesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "profile form is in Russian regardless of locale" do
    sign_in users(:one)
    I18n.with_locale(:en) do
      get edit_user_registration_path
      assert_response :success
      assert_select "h2", "Редактирование профиля"
      assert_select "label[for=user_email]", "Электронная почта"
      assert_select "label[for=user_password]", "Новый пароль"
      assert_select "label[for=user_password_confirmation]", "Подтверждение нового пароля"
      assert_select "label[for=user_current_password]", "Текущий пароль"
      assert_select "input[type=submit][value=?]", "Сохранить изменения"
      assert_select "button", text: "Удалить учётную запись"
      assert_select "a", text: "Назад"
      assert_includes response.body, "оставьте пустым"
      assert_includes response.body, "Минимум символов:"
      assert_not_includes response.body, "Cancel my account"
    end
  end

  test "field labels stay Russian with English locale" do
    I18n.with_locale(:en) do
      get new_user_session_path
      assert_select "label[for=user_email]", "Электронная почта"
      assert_select "label[for=user_password]", "Пароль"
      get new_user_registration_path
      assert_select "label[for=user_email]", "Электронная почта"
      assert_select "label[for=user_password]", "Пароль"
      assert_select "label[for=user_password_confirmation]", "Подтверждение пароля"
    end
  end

  test "login form is in Russian" do
    get new_user_session_path
    assert_response :success
    assert_select "h2", "Войти"
    assert_select "label[for=user_email]", "Электронная почта"
    assert_select "label[for=user_password]", "Пароль"
    assert_select "label[for=user_remember_me]", "Запомнить меня"
    assert_select "input[type=submit][value=?]", "Войти"
    assert_select "a", text: "Забыли пароль?"
  end

  test "registration form and validation errors are in Russian" do
    get new_user_registration_path
    assert_response :success
    assert_select "h2", "Зарегистрироваться"
    assert_select "label[for=user_password_confirmation]", "Подтверждение пароля"
    assert_select "input[type=submit][value=?]", "Зарегистрироваться"
    assert_includes response.body, "символов минимум"

    post user_registration_path, params: { user: { email: "invalid", password: "123", password_confirmation: "321" } }
    assert_response :unprocessable_content
    assert_select "#error_explanation", text: /Не удалось сохранить/
    assert_select "#error_explanation li", text: /Пароль слишком короткий/
    assert_not_includes response.body, "Translation missing"
  end
end
