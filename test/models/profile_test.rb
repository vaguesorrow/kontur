require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  test "belongs to a user with a profile" do
    assert_equal users(:one), profiles(:one).user
    assert_equal profiles(:one), users(:one).profile
  end

  test "requires user and display name" do
    profile = Profile.new
    assert_not profile.valid?
    assert profile.errors.of_kind?(:user, :blank)
    assert profile.errors.of_kind?(:display_name, :blank)
  end

  test "allows optional avatar and bio" do
    profile = profiles(:one)
    profile.update!(avatar_url: nil, bio: nil)
    assert_nil profile.reload.avatar_url
    assert_nil profile.bio
  end

  test "only allows one profile per user" do
    profile = Profile.new(user: users(:one), display_name: "Another profile")
    assert_not profile.valid?
    assert profile.errors.of_kind?(:user_id, :taken)
  end

  test "deleting user deletes profile" do
    user = User.create!(email: "profile@example.com", password: "password123")
    profile = user.create_profile!(display_name: "Applicant")
    user.destroy!
    assert_not Profile.exists?(profile.id)
  end
end
