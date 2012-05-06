require 'test_helper'

class WaypointsControllerTest < ActionController::TestCase
  setup do
    @waypoint = waypoints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:waypoints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create waypoint" do
    assert_difference('Waypoint.count') do
      post :create, waypoint: { elevation: @waypoint.elevation, lat: @waypoint.lat, lon: @waypoint.lon, name: @waypoint.name }
    end

    assert_redirected_to waypoint_path(assigns(:waypoint))
  end

  test "should show waypoint" do
    get :show, id: @waypoint
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @waypoint
    assert_response :success
  end

  test "should update waypoint" do
    put :update, id: @waypoint, waypoint: { elevation: @waypoint.elevation, lat: @waypoint.lat, lon: @waypoint.lon, name: @waypoint.name }
    assert_redirected_to waypoint_path(assigns(:waypoint))
  end

  test "should destroy waypoint" do
    assert_difference('Waypoint.count', -1) do
      delete :destroy, id: @waypoint
    end

    assert_redirected_to waypoints_path
  end
end
