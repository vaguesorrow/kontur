require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "defaults to user role" do
    assert User.new.user?
  end

  test "accepts admin and rejects unknown roles" do
    user = User.new(email: "admin@example.com", password: "password123", role: "admin")
    assert user.valid?
    assert user.admin?
    user.role = "owner"
    assert_not user.valid?
    assert user.errors.added?(:role, :inclusion, value: "owner")
  end

  test "stores profile and authenticates using password digest" do
    user = User.create!(username: "applicant", email: "applicant@example.com", password: "password123")
    user.reload
    assert_equal "applicant", user.username
    assert user[:password_digest].present?
    assert_not_equal "password123", user[:password_digest]
    assert_equal user[:password_digest], user.encrypted_password
    assert user.valid_password?("password123")
    assert_not user.valid_password?("incorrect")

    user.update!(password: "replacement123")
    user.reload
    assert user.valid_password?("replacement123")
    assert_not user.valid_password?("password123")
  end
end
