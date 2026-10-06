require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
    assert_select "select[name='project[user_id]'] option[value=?]", users(:one).id.to_s, text: users(:one).email
    assert_select "textarea[name='project[description]']"
    assert_select "input[name='project[string]'], input[name='project[text]']", count: 0
  end

  test "should create project" do
    assert_difference("Project.count") do
      post projects_url, params: { project: { description: @project.description, name: @project.name, user_id: @project.user_id } }
    end

    assert_redirected_to project_url(Project.last)
    assert_equal @project.user, Project.last.user
  end

  test "should reject project without user" do
    assert_no_difference("Project.count") do
      post projects_url, params: { project: { name: "Project", description: "Description" } }
    end
    assert_response :unprocessable_content
  end

  test "should show project as json" do
    get project_url(@project, format: :json)
    assert_response :success
    assert_equal @project.user_id, response.parsed_body["user_id"]
    assert_not response.parsed_body.key?("string")
    assert_not response.parsed_body.key?("text")
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { description: @project.description, name: @project.name, user_id: @project.user_id } }
    assert_redirected_to project_url(@project)
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
