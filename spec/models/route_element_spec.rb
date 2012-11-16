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

      rea = RouteElement.new
      rea.waypoint = ws[0]
      rea.route = r
      rea.save!

      rea.previous_route_element_id.should be_nil
      rea.previous_route_element.should be_nil
      rea.next_route_element_id.should be_nil
      rea.next_route_element.should be_nil

      r.reload
      r.last_route_element_id.should == rea.id

      # and another

      reb = RouteElement.new
      reb.waypoint = ws[1]
      reb.route = r
      reb.save!

      reb.previous_route_element_id.should == rea.id
      reb.previous_route_element.should == rea
      reb.next_route_element_id.should be_nil
      reb.next_route_element.should be_nil

      rea.previous_route_element_id.should be_nil
      rea.previous_route_element.should be_nil
      rea.next_route_element_id.should == reb.id
      rea.next_route_element.should == reb

      r.reload
      r.last_route_element_id.should == reb.id

      puts RouteElement.all.to_yaml
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
