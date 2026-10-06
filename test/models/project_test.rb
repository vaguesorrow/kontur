require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "requires a user" do
    project = Project.new(name: "Project", description: "Description")
    assert_not project.valid?
    assert project.errors.of_kind?(:user, :blank)
  end

  test "belongs to a user" do
    project = projects(:one)
    assert_equal users(:one), project.user
    assert_includes users(:one).projects, project
    assert project.valid?
  end
end
