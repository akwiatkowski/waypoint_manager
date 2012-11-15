require 'spec_helper'

describe RouteElement do
  context 'creating' do
    it "manual create route and elements" do
      a = FactoryGirl.create(:area)
      ws = Array.new
      5.times do
        ws << FactoryGirl.create(:waypoint, area: a)
      end

      r = Route.new
      r.area = a
      r.name = 'test'
      r.save!
    end

    #it "should create from factory" do
    #  m = FactoryGirl.create(:route_element)
    #  m.should be_valid
    #end
    #
    #it "should create from factory with 2 route elements" do
    #  m = FactoryGirl.create(:route)
    #
    #  m.route_elements << FactoryGirl.create(:route_element)
    #  m.route_elements << FactoryGirl.create(:route_element)
    #  m.should be_valid
    #
    #  m.save!
    #
    #  m.reload
    #  m.route_elements.size.should == 2
    #end
    #
    #it "should calculate correct distance" do
    #  m = FactoryGirl.create(:route)
    #
    #  m.route_elements << FactoryGirl.create(:route_element)
    #  m.route_elements << FactoryGirl.create(:route_element)
    #  m.should be_valid
    #
    #  m.save!
    #
    #  m.reload
    #  m.route_elements.size.should == 2
    #
    #  # checking 0 distance
    #  route_element = m.route_elements[0]
    #  route_element.start.distance_to(route_element.finish).should == 0.0
    #
    #  route_element.distance.should == 0.0
    #end
  end
end
