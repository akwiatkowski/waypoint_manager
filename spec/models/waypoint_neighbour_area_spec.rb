# encoding: utf-8

require 'spec_helper'

describe WaypointNeighbourArea, :type => :model do
  it "create waypoint between two areas" do
    area_original = FactoryGirl.create(:area)
    area_neighbour = FactoryGirl.create(:area)
    area_original.should be_valid
    area_neighbour.should be_valid

    # create w.
    w = FactoryGirl.create(:waypoint, area: area_original)
    w.should be_valid

    # check and add other area as neighbour
    w.neighbour_areas.should be_kind_of(Array)
    w.neighbour_areas.should be_empty

    w.neighbour_areas << area_neighbour
    w.should be_valid
    w.save!
    
    # create another w. and add to neighbour area
    w_in_neighbour = FactoryGirl.create(:waypoint, area: area_neighbour)
    w_in_neighbour.should be_valid

    w.neighbour_areas.size.should == 1
    w.neighbour_areas.first.waypoints.should == w.neighbour_waypoints
    w.neighbour_areas.first.waypoints.should == w.neighbour_waypoints

    # most important test
    w.neighbour_waypoints.should == area_neighbour.waypoints

    area_original.reload
    area_neighbour.reload

    # access from area
    area_original.waypoints.size.should == 1
    area_original.waypoints.first.should == w

    area_original.neighbour_areas_via_waypoints.size.should == 1
    area_original.neighbour_areas_via_waypoints.first.should == area_neighbour

    area_original.neighbour_waypoints_via_waypoints.size.should == 1
    area_original.neighbour_waypoints_via_waypoints.first.should == w_in_neighbour

    # add waypoint to original
    w_somewhere = FactoryGirl.create(:waypoint, area: area_original)
    w_somewhere.should be_valid
    area_original.reload
    area_neighbour.reload

    # there is no info that this w. is near other area
    w_somewhere.neighbour_waypoints.should be_empty
  end
end